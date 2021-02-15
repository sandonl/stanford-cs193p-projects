//
//  MemoryGame.swift
//  memorise-app
//
//  Model code.
//  Created by Sandon Lai on 12/2/21.
//

import Foundation

// Model in the MVVM
struct MemoryGame<CardContent> {
    var cards: Array<Card>
    
    // Functions that mutate a structure must be marked with 'mutating'
    mutating func choose(card: Card){
        print("Card chosen: \(card)")
        let chosenIndex: Int = self.index(of: card)
        // Flips the cards once chosen
        self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
    }
    
    // external name - of, internal name - card
    func index(of card: Card) -> Int {
        for index in 0..<self.cards.count {
            if self.cards[index].id == card.id {
                return index
            }
        }
        return 0 // TODO: wrong index returned after fail search of index 
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
