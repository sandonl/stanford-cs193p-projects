//
//  OptionalImage.swift
//  emoji-art
//
//  Created by Sandon Lai on 23/2/21.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
                if uiImage != nil {
                    Image(uiImage: uiImage!)
            }
        }
    }
}
