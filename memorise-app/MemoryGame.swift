//
//  MemoryGame.swift
//  memorise-app
//
//  Model code.
//  Created by Sandon Lai on 12/2/21.
//

import Foundation

// Model in the MVVM
struct MemoryGame<CardContent> where CardContent: Equatable{
    var cards: Array<Card>
    
    // Optionals get initialised to nil automatically.
    var indexOfTheOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    // Functions that mutate a structure must be marked with 'mutating'
    // Game mechanics
    mutating func choose(card: Card){
        // only runs if returns non nil. (will pass the unwrapped Int)
        if let chosenIndex: Int = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                self.cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOnlyFaceUpCard = chosenIndex
            }
        }
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
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        
    }
}
