//
//  QuoteStore.swift
//  Marathoner
//
//  Created by Jonathan Wong on 1/25/19.
//  Copyright © 2019 Jonathan Wong. All rights reserved.
//

import Foundation

final class QuoteStore {
    
    static let shared = QuoteStore()
    
    static let quotes = [
        "Keep it going!",
        "You got this!",
        "Plenty left in the tank!",
        "Stay over your work!",
        "Wow, you are on fire!",
        "Don't step off the gas!",
        "Doesn't it feel great to run that fast!",
        "Keep trucking!",
        "See you at the finish line!",
        "You can do it!",
        "One step at a time!",
        "One mile at a time!",
    ]

    class func quote() -> String {
        let random = Int.random(in: 0..<quotes.count)
        return quotes[random]
    }
}
