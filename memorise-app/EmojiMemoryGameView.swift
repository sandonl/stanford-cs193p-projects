//
//  EmojiMemoryGameView.swift
//  memorise-app
//
//  Created by Sandon Lai on 12/2/21.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    // ObservedObject - will redraw the view
    @ObservedObject var viewModel: EmojiMemoryGame // This is a viewModel but we shouldn't call this it usually
    
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
        
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {
        ZStack {
            if self.card.isFaceUp {
                RoundedRectangle(cornerRadius: self.cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: self.cornerRadius).stroke(lineWidth: lineWidth)
                Text(self.card.content)
            } else {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }
        // Now letting the card set its own font using geometry reader
        .font(Font.system(size: fontSize(for: size)))
    }
    
    
    // MARK: - Drawing Constants
    let cornerRadius: CGFloat = 10.0
    let lineWidth: CGFloat = 3.0
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
}
