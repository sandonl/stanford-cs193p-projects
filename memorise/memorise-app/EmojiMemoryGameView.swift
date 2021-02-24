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
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.75)){
                        self.viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
                .padding()
            .foregroundColor(Color.red)
            
            // Implementing a new game button, note that strings are not localised
            Button(action: {
                withAnimation(.easeInOut) {
                    self.viewModel.resetGame()
                }
            }, label: {
                Text("New Game")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.yellow)
                    .cornerRadius(10)
            })
        }
        
            
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    // needs to be synced up with the model (since the model doesn't always update our view we need to introduce this @State)
    // to update from our model
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        // animates ticking down to 0
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    // Either a ZStack or an empty view
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear{
                                self.startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }.padding(5)
                .opacity(0.4)
                .transition(.scale)

                Text(self.card.content)
                    // Now letting the card set its own font using geometry reader
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 :0))
                    // Implict animation here (duration of 1 second)
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)

        }
    }
    
    
    // MARK: - Drawing Constants
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            let game = EmojiMemoryGame()
            game.choose(card: game.cards[2])
            return EmojiMemoryGameView(viewModel: game)
        }
    }
}
