//
//  emoji_artApp.swift
//  emoji-art
//
//  Created by Sandon Lai on 22/2/21.
//

import SwiftUI

@main
struct emoji_artApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
