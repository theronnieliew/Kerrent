//
//  RentFeedTableViewCell.swift
//  Kerrent
//
//  Created by Clinton Otten on 08/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

class RentFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var rentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rentView.addGradient(firstColor: UIColor(netHex:0xbdc3c7).withAlphaComponent(0.5), secondColor: UIColor(netHex:0x2c3e50).withAlphaComponent(0.5))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
