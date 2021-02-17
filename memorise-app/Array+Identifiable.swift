//
//  Array+Identifiable.swift
//  memorise-app
//
//  Created by Sandon Lai on 16/2/21.
//

import Foundation

// Extension will only add this functionality (constrains and gains) to the Arrays where elements within are identifiable
extension Array where Element: Identifiable {
    // Allows us to gain this functionality for all arrays with this identifiable element
    // Int? indicates an optional (type) with an associated value of Int
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil // TODO: index not calculated properly
    }
}
