//
//  Array+Only.swift
//  memorise-app
// If the element is in the array (Extension to find if the element is in the array)
//
//  Created by Sandon Lai on 16/2/21.

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
