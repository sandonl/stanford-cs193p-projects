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
    
    // Setting this is private however reading this is not.
    private(set) var cards: Array<Card>
    
    // Optionals get initialised to nil automatically.
    // The user will pick one card (only faceup) and only when they pick a second one will the game try to match
    private var indexOfTheOnlyFaceUpCard: Int? {
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
        // Shuffles the cards (shuffles an array)
        cards.shuffle()
    }
    
    
    struct Card: Identifiable {
        // Will represent a single Memory Games card
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    // more reliable than trying to convert it this in our choose function
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        
        // This could give matching bonus points if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means 'no bonus available' for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card have ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so )
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // whether the ard was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
    }
}
