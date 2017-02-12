//
//  String.swift
//  Essentials
//
//  Created by Nicolaos Steinhauer on 12/02/2017.
//
//

import Foundation

public extension String {
    /// Add a `suffix` to the `self`.
    public func suffix(_ suffix: String) -> String {
        return self + suffix
    }
    
    /// Add a `prefix` to the `self`.
    public func prefix(_ prefix: String) -> String {
        return prefix + self
    }
}
