//
//  WorkoutTableViewCell.swift
//  Marathoner
//
//  Created by Jonathan Wong on 1/5/19.
//  Copyright © 2019 Jonathan Wong. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(title: String, quote: String) {
        workoutLabel.text = "\(title) mi"
        quoteLabel.text = quote
    }
    
    class func height() -> CGFloat {
        return 60.0
    }

}
