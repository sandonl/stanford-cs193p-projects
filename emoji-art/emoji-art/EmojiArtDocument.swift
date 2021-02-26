//
//  EmojiArtDocument.swift
//  emoji-art - ViewModel
//
//  Created by Sandon Lai on 22/2/21.
//

import SwiftUI
import Combine

// Implements ObservableObject
// An instance of this ViewModel only represents one document
class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "⭐️🍎⚾️🏓⚽️🐼"
    
    // Implement the model (view model which interprets the model for the view)
    // @Published // workaround for property observer problem with property wrappers
    @Published private var emojiArt: EmojiArt
    
    private static let untitled = "EmojiArtDocument.Untitled"
    
    private var autosaveCancellable: AnyCancellable?
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        // if never fails can use this version, need sink to live past the execution of the init
        autosaveCancellable = $emojiArt.sink { emojiArt in
            print("\(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
        fetchBackgroundImageData()
    }
    
    // Only our viewmodel will be setting images from the internet (published causes our view to  redraw) 
    @Published private(set) var backgroundImage: UIImage?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intent(s) of the user
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji (_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    private var fetchImageCancellable: AnyCancellable?
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            fetchImageCancellable?.cancel() // only ever fetch new image
            fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
                // has been mapped to publish a UI Image instead of the original tuple using .map
                // a publisher that publishes UIImages and on the main queue
                .map { data, urLResponse in UIImage(data: data) }
                .receive(on: DispatchQueue.main)
                // now publisher publishes optional image and its error type is now 'Never'
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }
    }
}


extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y))}
    
}
