//
//  EmojiArtDocument.swift
//  emoji-art - ViewModel
//
//  Created by Sandon Lai on 22/2/21.
//

import SwiftUI

// Implements ObservableObject
// An instance of this ViewModel only represents one document
class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "⭐️🍎⚾️🏓⚽️🐼"
    
    // Implement the model (view model which interprets the model for the view)
    // @Published // workaround for property observer problem with property wrappers
    private var emojiArt: EmojiArt = EmojiArt() {
        willSet {
            objectWillChange.send()
        }
        didSet {
            // UserDefaults standard for lightweight persistence
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
    }
    
    private static let untitled = "EmojiArtDocument.Untitled"
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
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
    
    func setBackground(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            // Initiate a queue that conducts its code off the main queue
            DispatchQueue.global(qos: .userInitiated).async {
                // cannot call this function by itself as it blocks our UI (same thread as our execution)
                if let imageData = try? Data(contentsOf: url) {
                    // now our background drawing is on a background thread, so we need to move this back to our main queue and use async
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}


extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y))}
    
}
