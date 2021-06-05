//
//  TableViewAction.swift
//  Marathoner
//
//  Created by Jonathan Wong on 1/24/19.
//  Copyright © 2019 Jonathan Wong. All rights reserved.
//

import Foundation

enum IndexPathAction {
    case reload
    case insertRow
    case insertSection
    case deleteRow
    case deleteSection
}

struct TableViewAction {
    let indexPathAction: IndexPathAction
    let indexPaths: [IndexPath]?
    let indexSet: IndexSet?
    
    init(indexPathAction: IndexPathAction, indexPaths: [IndexPath]? = nil, indexSet: IndexSet? = nil) {
        self.indexPathAction = indexPathAction
        self.indexPaths = indexPaths
        self.indexSet = indexSet
    }
}
