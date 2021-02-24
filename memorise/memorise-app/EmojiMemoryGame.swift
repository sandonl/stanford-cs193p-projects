//
//  EmojiMemoryGame.swift
//  memorise-app
//
//  Created by Sandon Lai on 13/2/21.🐼
import SwiftUI

// ViewModel: portal for view to get the model.
// It is the View that talks to the viewmodel, since many views may wish to use the same viewmodel, this is why it's a class (reference)
// ViewModel trying to convert to the MemoryGame model and also represent the View

// ObservableObject (protocol) that allows us to gain other functions that we can send to the view - only works for classes
class EmojiMemoryGame: ObservableObject {
    
    // Published, everytime the model changes, it will call objectWillChange.send()
    // Note we would never call a variable 'model' but instead is used for example and provides a 'doorway' for the view
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // static func makes this sent to the type
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["🤯", "🐼", "🌏"]
        
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
    
    // Allows the user to choose a card.
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    // Creates a new game
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    
    
}
