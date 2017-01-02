//
//  Rounder.swift
//  Essentials_iOS
//
//  Created by Nicolaos Steinhauer on 27/11/2016.
//  Copyright © 2016 Express Publishing. All rights reserved.
//

import Foundation

/// Round the provided `decimal` to a certain number of `decimalPlaces`.
///
/// - parameters:
///     - decimal: the decimal input.
///     - decimalPlaces: the number of decimal places to round the input.
func round(_ decimal: Double, to decimalPlaces: Int) -> Double {
    let divisor = pow(10, Double(decimalPlaces))
    return round(decimal * divisor) / divisor
}
