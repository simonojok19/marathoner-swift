//
//  DataStore.swift
//  Marathoner
//
//  Created by Jonathan Wong on 1/19/19.
//  Copyright © 2019 Jonathan Wong. All rights reserved.
//

import Foundation
import DateUtilities
final class DataStore {
    
    enum Section: Int {
        case date
        case workout
        case overview
    }
    
    enum Row: Int {
        case start
        case end
    }
    
    var weeks: Int
    var dateModels: [DateModel]
    var previousWeeks = 0
    var workoutVisible = false
    var runs: [Int] = []
    var totalDistance = 0
    var fullMarathon = true
    
    init(dateModels: [DateModel], weeks: Int) {
        self.dateModels = dateModels
        self.weeks = weeks
    }
}

extension DataStore {
    
    func setValid() {
        for i in 0..<self.dateModels.count {
            dateModels[i].isValid = true
        }
    }
}

extension DataStore {
    
    var start: DateModel {
        get {
            return dateModels[Row.start.rawValue]
        }
    }
    
    var end: DateModel {
        get {
            return dateModels[Row.end.rawValue]
        }
    }
    
    var difference: Int {
        return weeks - previousWeeks
    }
    
    var insertableSectionsIndexPaths: IndexSet {
        get {
            return IndexSet(integersIn: Section.workout.rawValue...Section.overview.rawValue)
        }
    }
    
    func indexPathsToInsert(previousWeeks: Int, difference: Int, section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for row in previousWeeks..<(previousWeeks + difference) {
            indexPaths.append(IndexPath(row: row, section: section))
        }
        return indexPaths
    }
    
    func indexPathsToReload(limit: Int, section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for index in 0..<limit {
            indexPaths.append(IndexPath(row: index, section: section))
        }
        return indexPaths
    }
    
    func indexPathsToDelete(previousWeeks: Int, end: Int, section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for index in stride(from: previousWeeks - 1, to: end - 1, by: -1) {
            indexPaths.append(IndexPath(row: index, section: section))
        }
        return indexPaths
    }
    
    func indexPathActions(from: Date, to: Date, indexPath: IndexPath) -> [TableViewAction] {
        var tableViewActions = [TableViewAction]()
        let valid = DateLogic.validate(from: from, to: to)
        if !valid {
            dateModels[indexPath.row].isValid = false
            
            // reload the invalid row with date
            tableViewActions.append(TableViewAction(indexPathAction: .reload, indexPaths: [indexPath]))
            
            // remove workout
            if workoutVisible {
                tableViewActions.append(TableViewAction(indexPathAction: .deleteSection, indexSet: insertableSectionsIndexPaths))
                workoutVisible = false
            }
        } else {
            setValid()
            if indexPath.row == Row.end.rawValue {
                let startIndexPath = IndexPath(row: Row.start.rawValue, section: Section.date.rawValue)
                tableViewActions.append(TableViewAction(indexPathAction: .reload, indexPaths: [startIndexPath, indexPath]))
            } else if indexPath.row == Row.start.rawValue {
                // this doesn't work bc when u call updateCell, row 2 is not a valid dataModel
                let endIndexPath = IndexPath(row: Row.end.rawValue, section: Section.date.rawValue)
                tableViewActions.append(TableViewAction(indexPathAction: .reload, indexPaths: [endIndexPath, indexPath]))
            }
            // reload the valid row with date
            tableViewActions.append(TableViewAction(indexPathAction: .reload, indexPaths: [indexPath]))
            
            weeks = DateLogic.weeks(from: from, to: to)
            if weeks == 0 && !workoutVisible {
                // nothing to update
                 return tableViewActions
            } else if weeks != 0 {
                let factor = fullMarathon ? 20 : 10
                let (longRuns, sum) = RunLogic.distance(for: weeks, factor: factor)
                runs = longRuns.reversed()
                totalDistance = sum
            }

            if !workoutVisible {
                tableViewActions.append(TableViewAction(indexPathAction: .insertSection, indexSet: insertableSectionsIndexPaths))
                workoutVisible = true
            } else {
                let difference = weeks - previousWeeks
                
                if difference == 0 {
                    // no insertion or deletion required
                    return tableViewActions
                } else if difference > 0 {
                    // insert rows
                    let indexPaths = indexPathsToInsert(previousWeeks: previousWeeks, difference: difference, section: Section.workout.rawValue)
                    tableViewActions.append(TableViewAction(indexPathAction: .insertRow, indexPaths: indexPaths))
                    let reloadIndexPaths = indexPathsToReload(limit: previousWeeks, section: Section.workout.rawValue)
                    tableViewActions.append(TableViewAction(indexPathAction: .reload, indexPaths: reloadIndexPaths))
                } else {
                    let end = previousWeeks + difference
                    if weeks == 0 {
                        tableViewActions.append(TableViewAction(indexPathAction: .deleteSection, indexSet: insertableSectionsIndexPaths))
                        workoutVisible = false
                    } else {
                        let indexPaths = indexPathsToDelete(previousWeeks: previousWeeks, end: end, section: Section.workout.rawValue)
                        tableViewActions.append(TableViewAction(indexPathAction: .deleteRow, indexPaths: indexPaths))
                        let reloadIndexPaths = indexPathsToReload(limit: end, section: Section.workout.rawValue)
                        tableViewActions.append(TableViewAction(indexPathAction: .reload, indexPaths: reloadIndexPaths))
                    }
                }
            }
        }
        previousWeeks = weeks
        
        return tableViewActions
    }
}
