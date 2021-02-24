//
//  Cardify.swift
//  memorise-app
//
//  Created by Sandon Lai on 18/2/21.
//

import SwiftUI

// This viewmodifier is marked as non-animatable, we just change this to AnimatableModifier (ViewModifier + Animatable)
// ViewModifier + Animatable
struct Cardify: AnimatableModifier{
    
    var rotation: Double
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    // This is just a computation of rotation
    var isFaceUp: Bool {
        rotation < 90
    }
    
    // Animates the rotation of our view
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    // Content is a 'don't care from the protocol ViewModifier'
    // Content is the ZStack in the view that we are 'modifying'
    func body(content: Content) -> some View {
        ZStack{
            Group {
                RoundedRectangle(cornerRadius: self.cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: self.cornerRadius).stroke(lineWidth: lineWidth)
                content // technically always on screen, it's just hidden
            }
            // We will just use opacity as a trick to control whether we are controlling views already on screen
                .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius).fill()
                .opacity(isFaceUp ? 0 : 1)
            // will draw an empty view when the card has already beeen matched
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
        
    // MARK: Drawing Constants
        private let cornerRadius: CGFloat = 10.0
        private let lineWidth: CGFloat = 3.0
}

// For nicer syntax 
extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}



