//
//  DateTableViewCell.swift
//  Marathoner
//
//  Created by Jonathan Wong on 12/30/18.
//  Copyright © 2018 Jonathan Wong. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var dateModel: DateModel? {
        didSet {
            if let dateModel = dateModel {
                updateCell(with: dateModel)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(title: String, date: Date) {
        titleLabel.text = title
        dateLabel.text = DateConverter.shared.formatDate(date)
    }

    func updateCell(with dateModel: DateModel) {
        titleLabel.text = dateModel.title
        let dateText = DateConverter.shared.formatDate(dateModel.date)
        dateLabel.text = dateText
        if dateModel.isValid {
            let attributes = [:] as [NSAttributedString.Key: Any]
            dateLabel.attributedText = NSAttributedString(string: dateText, attributes: attributes)
            dateLabel.textColor = UIColor.black
        } else {
            let attributes = [NSAttributedString.Key.strokeColor: UIColor.red,
                              NSAttributedString.Key.strikethroughColor: UIColor.red,
                              NSAttributedString.Key.strikethroughStyle: 1] as [NSAttributedString.Key: Any]
            dateLabel.attributedText = NSAttributedString(string: dateText, attributes: attributes)
            dateLabel.textColor = UIColor.red
        }
    }

    class func height() -> CGFloat {
        return 60.0
    }
}


