//
//  EmojiArt.swift
//  emoji-art - Model
//
//  Created by Sandon Lai on 22/2/21.
//

import Foundation

// encodable, depending if the var's are encodable themselves
struct EmojiArt: Codable {
    
    // Optional because we have a document that can have no background
    var backgroundURL : URL?
    var emojis = [Emoji]()
    
    struct Emoji: Identifiable, Codable {
        let text: String // Once we create an emoji, it will always be this emoji (never will be changed)
        var x: Int // offset from the center
        var y: Int // offset from the center
        var size: Int
        let id: Int
        
        // fileprivate - makes this private only in this file, gives EmojiArt power to call and create, but also allows users
        // to edit the x, y and size still. 
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    // Encoding self as a json
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    // Code to decode ourself
    // init? if returns nil, will return nil - we also lose our free init so we have to add this back
    init?(json: Data?) {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!) {
            self = newEmojiArt
        } else {
            return nil
        }
    }
    
    init() { }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
    
    
    
    
    
    
}
