//
//  EmojiMemoryGameView.swift
//  memorise-app
//
//  Created by Sandon Lai on 12/2/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    var viewModel: EmojiMemoryGame // This is a viewModel but we shouldn't call this it usually
    
    // We never access this 'var body'
    // This body is instead called by the system when it draws the view.
    var body: some View {
        HStack {
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture{
                    viewModel.choose(card: card) }
            }
        }.padding()
        .foregroundColor(Color.orange)
        .font(Font.largeTitle)
        .aspectRatio(0.66, contentMode: .fit)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
}
