//
//  OverviewTableViewCell.swift
//  Marathoner
//
//  Created by Jonathan Wong on 1/5/19.
//  Copyright © 2019 Jonathan Wong. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var weeksLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(weeks: Int, distance: Int) {
        if weeks == 0 {
            weeksLabel.text = ""
        } else {
            let weekText = weeks == 1 ? "week" : "weeks"
            weeksLabel.text = "\(String(weeks)) \(weekText) to go"
            totalDistanceLabel.text = "\(distance) miles"
        }
    }

    class func height() -> CGFloat {
        return 60.0
    }
}
