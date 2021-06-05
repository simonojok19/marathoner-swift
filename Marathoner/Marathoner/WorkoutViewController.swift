//
//  WorkoutViewController.swift
//  Marathoner
//
//  Created by Jonathan Wong on 2/6/19.
//  Copyright © 2019 Jonathan Wong. All rights reserved.
//

import UIKit

class WorkoutViewController: UIViewController {

    @IBOutlet weak var halfMarathonButton: UIButton!
    @IBOutlet weak var fullMarathonButton: UIButton!
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var halfMarathonLabel: UILabel!
    @IBOutlet weak var fullMarathonLabel: UILabel!
    
    var dataStore: DataStore!
    var quoteStore: QuoteStore!
    var datePickerIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        halfMarathonButton.addTarget(self, action: #selector(onHalfMarathonButtonPressed(_:)), for: .touchUpInside)
        fullMarathonButton.addTarget(self, action: #selector(onFullMarathonButtonPressed(_:)), for: .touchUpInside)
        
        view.addConstraint(NSLayoutConstraint(item: halfMarathonLabel, attribute: .centerX, relatedBy: .equal, toItem: halfMarathonButton, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: halfMarathonLabel, attribute: .top, relatedBy: .equal, toItem: halfMarathonButton, attribute: .bottom, multiplier: 1.0, constant: 8.0))
        view.addConstraint(NSLayoutConstraint(item: halfMarathonLabel, attribute: .bottom, relatedBy: .equal, toItem: eventTableView, attribute: .top, multiplier: 1.0, constant: 8.0))
    }
    
    func datePickerInsertIndexPath(indexPath: IndexPath) -> IndexPath {
        if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row < indexPath.row {
            return indexPath
        } else {
            return IndexPath(row: indexPath.row + 1, section: indexPath.section)
        }
        
    }
    
    @objc func onHalfMarathonButtonPressed(_ sender: UIButton) {
        dataStore.fullMarathon = false
    }
    
    @objc func onFullMarathonButtonPressed(_ sender: UIButton) {
        dataStore.fullMarathon = true
    }
}

extension WorkoutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataStore.workoutVisible {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == DataStore.Section.date.rawValue {
            if datePickerIndexPath != nil {
                return dataStore.dateModels.count + 1
            } else {
                return dataStore.dateModels.count
            }
        } else if section == DataStore.Section.workout.rawValue {
            return dataStore.weeks
        } else if section == DataStore.Section.overview.rawValue {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == DataStore.Section.date.rawValue {
            if datePickerIndexPath == indexPath {
                let datePickerCell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell") as! DatePickerTableViewCell
                datePickerCell.updateCell(date: dataStore.dateModels[indexPath.row - 1].date, indexPath: indexPath)
                datePickerCell.delegate = self
                
                return datePickerCell
            } else {
                let dateCell = tableView.dequeueReusableCell(withIdentifier: "DateTableViewCell") as! DateTableViewCell
                dateCell.updateCell(with: dataStore.dateModels[indexPath.row])
                
                return dateCell
            }
        } else if indexPath.section == DataStore.Section.workout.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTableViewCell") as! WorkoutTableViewCell
            cell.updateCell(title: "\(dataStore.runs[indexPath.row])", quote: QuoteStore.quote())
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewTableViewCell") as! OverviewTableViewCell
            cell.updateCell(weeks: dataStore.weeks, distance: dataStore.totalDistance)
            
            return cell
        }
    }
}

extension WorkoutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == DataStore.Section.date.rawValue {
            tableView.beginUpdates()
            if let datePickerIndexPath = datePickerIndexPath, datePickerIndexPath.row - 1 == indexPath.row {
                tableView.deleteRows(at: [datePickerIndexPath], with: .automatic)
                self.datePickerIndexPath = nil
            } else {
                if let datePickerIndexPath = datePickerIndexPath {
                    tableView.deleteRows(at: [datePickerIndexPath], with: .automatic)
                }
                datePickerIndexPath = datePickerInsertIndexPath(indexPath: indexPath)
                tableView.insertRows(at: [datePickerIndexPath!], with: .automatic)
            }
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.endUpdates()
        } else if indexPath.section == DataStore.Section.overview.rawValue {
            
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == DataStore.Section.date.rawValue {
            if datePickerIndexPath == indexPath {
                return DatePickerTableViewCell.height()
            } else {
                return DateTableViewCell.height()
            }
        } else if indexPath.section == DataStore.Section.overview.rawValue {
            return WorkoutTableViewCell.height()
        } else {
            return OverviewTableViewCell.height()
        }
    }
}

extension WorkoutViewController: DatePickerDelegate {
    
    func didChangeDate(date: Date, indexPath: IndexPath) {
        // set the date from what's in the picker
        dataStore.dateModels[indexPath.row].date = date
        
        let tableViewActions = dataStore.indexPathActions(from: dataStore.start.date, to: dataStore.end.date, indexPath: indexPath)
        eventTableView.beginUpdates()
        _ = tableViewActions.map { action in
            switch action.indexPathAction {
            case .reload:
                guard let indexPaths = action.indexPaths else {
                    return
                }
                eventTableView.reloadRows(at: indexPaths, with: .none)
            case .insertRow:
                guard let indexPaths = action.indexPaths else {
                    return
                }
                eventTableView.insertRows(at: indexPaths, with: .automatic)
            case .insertSection:
                guard let indexSet = action.indexSet else {
                    return
                }
                eventTableView.insertSections(indexSet, with: .automatic)
            case .deleteRow:
                guard let indexPaths = action.indexPaths else {
                    return
                }
                eventTableView.deleteRows(at: indexPaths, with: .automatic)
            case .deleteSection:
                guard let indexSet = action.indexSet else {
                    return
                }
                eventTableView.deleteSections(indexSet, with: .automatic)
            }
        }
        eventTableView.endUpdates()
    }
}
