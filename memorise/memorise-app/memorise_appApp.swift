//
//  memorise_appApp.swift
//  memorise-app
//
//  Created by Sandon Lai on 12/2/21.
//

import SwiftUI

@main
struct memorise_appApp: App {
    var body: some Scene {
        let game = EmojiMemoryGame()
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
