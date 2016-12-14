//
//  DetailedCarTableViewCell.swift
//  Kerrent
//
//  Created by Clinton Otten on 08/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

class DetailedCarTableViewCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carLogo: UIImageView!

    @IBOutlet weak var bookingTitle: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateStartLabel: UILabel!
    @IBOutlet weak var dateEndLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    
    @IBOutlet weak var specsLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var transmissionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
