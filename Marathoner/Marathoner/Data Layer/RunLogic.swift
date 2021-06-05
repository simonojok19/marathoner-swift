//
//  RunLogic.swift
//  Marathoner
//
//  Created by Jonathan Wong on 1/1/19.
//  Copyright © 2019 Jonathan Wong. All rights reserved.
//

import Foundation

struct RunLogic {
    
    static func distance(for weeks: Int, factor: Int) -> (runs: [Int], sum: Int) {
        let interval = factor / weeks
        var sum = 0
        
        var runs = [Int]()
        for run in stride(from: factor, through: interval, by: -interval) {
            runs.append(run)
            sum += run
        }
        
        return (runs, sum)
    }
}
