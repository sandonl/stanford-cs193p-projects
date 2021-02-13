//
//  MemoryGame.swift
//  memorise-app
//
//  Model code.
//  Created by Sandon Lai on 12/2/21.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    func choose(card: Card){
        // Logic of game matching cards
        print("Card chosen: \(card)")
        
    }
    
    // Initialise our model (note passes through a function)
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>() // An empty array of cards
        
        // Iterate through our pairs and append the cards to our empty array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
    }
    
    struct Card: Identifiable {
        // Will represent a single Memory Games card
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        
    }
}
