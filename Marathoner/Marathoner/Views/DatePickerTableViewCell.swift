//
//  DatePickerTableViewCell.swift
//  Marathoner
//
//  Created by Jonathan Wong on 12/30/18.
//  Copyright © 2018 Jonathan Wong. All rights reserved.
//

import UIKit

protocol DatePickerDelegate: class {
    func didChangeDate(date: Date, indexPath: IndexPath)
}

class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var indexPath: IndexPath?
    weak var delegate: DatePickerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(date: Date, indexPath: IndexPath) {
        datePicker.setDate(date, animated: true)
        self.indexPath = indexPath
    }
    
    
    @objc func dateDidChange(_ sender: UIDatePicker) {
        guard let indexPath = indexPath else {
            return
        }
        let dateIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        delegate?.didChangeDate(date: sender.date, indexPath: dateIndexPath)
    }
    
    class func height() -> CGFloat {
        return 162.0
    }
}
