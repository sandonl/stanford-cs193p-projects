//
//  EmojiMemoryGame.swift
//  memorise-app
//
//  Created by Sandon Lai on 13/2/21.
//

import SwiftUI

// ViewModel: portal for tview to get the model.
// It is the View that talks to the viewmodel, since many views may wish to use the same viewmodel, this is why it's a class (reference)
// ViewModel trying to convert to the MemoryGame model and also represent the View
class EmojiMemoryGame {
    
    private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // static func makes this sent to the type
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["🤯", "🐼", "🌏"]
        // this is a closure and we pass an inline function (one line function that returns)
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
        
    
    // MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: -Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    
}
