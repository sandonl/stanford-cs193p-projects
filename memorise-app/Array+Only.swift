//
//  Array+Only.swift
//  memorise-app
//
//  Created by Sandon Lai on 16/2/21.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
