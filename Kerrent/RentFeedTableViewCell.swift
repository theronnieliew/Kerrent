//
//  RentFeedTableViewCell.swift
//  Kerrent
//
//  Created by Clinton Otten on 08/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

class RentFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!{
        didSet{
            carImage.round(corners: [.topLeft, .topRight], radius: 2)
        }
    }
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var rentView: UIView!{
        didSet{
//            rentView.addGradient(firstColor: UIColor.clear, secondColor: UIColor.clear)
            rentView.fullyRound(diameter: 2, borderColor: UIColor.clear, borderWidth: 0)
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

}
