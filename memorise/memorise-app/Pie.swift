//
//  Pie.swift
//  memorise-app
//
//  Created by Sandon Lai on 17/2/21.
//

import SwiftUI

struct Pie: Shape {
    
    // Properties 
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    
    // being sliced up into pieces by the animation system
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    // CGRect is the space offered to it
    func path(in rect: CGRect) -> Path {
        
        // Properties 
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 clockwise: clockwise
        )
        
        p.addLine(to: center)
        return p
    }
}
