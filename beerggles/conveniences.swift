//
//  conveniences.swift
//  beerggles
//
//  Created by Jerry Tsai on 2016-04-25.
//
//

import Foundation

/// Taken from Yannickstephan.com - redwolfstudio.fr
public extension Double {
    /// Return a random Double between 0.0 and 1.0, inclusive
    public static var random:Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }
    
    /// Create a random number Double
    ///
    /// - parameter min: Double
    /// - parameter max: Double
    /// - returns: Double
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}
