//
//  HistoryTableViewCell.swift
//  Kerrent
//
//  Created by Clinton Otten on 15/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var rentCarNameLabel: UILabel!
    
    @IBOutlet weak var directionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
