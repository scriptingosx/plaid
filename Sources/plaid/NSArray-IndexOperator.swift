//
//  NSArray-IndexOperator.swift
//  plaid
//
//  Created by Armin Briegel on 24.07.19.
//

import Foundation

// extend the NSArray class with an @index keypath operator
// follwoing this: https://funwithobjc.tumblr.com/post/1527111790/defining-custom-key-path-operators

@objc extension NSArray {
    func _index(forKeyPath keyPath: String) -> Any? {
        let keyPathElements = keyPath.components(separatedBy: ".")
        guard let indexString = keyPathElements.first else { return nil }
        guard let objectIndex = Int(indexString) else {
            return nil
        }
        let remainingKeyPath = keyPathElements.dropFirst().joined(separator: ".")
        if self.count > objectIndex {
            let object = self.object(at: objectIndex) as? NSObject
            if remainingKeyPath.isEmpty {
                return object
            } else {
                return object?.value(forKeyPath: remainingKeyPath)
            }
        } else {
            return nil
        }
    }
}
