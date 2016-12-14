//
//  DetailedCarViewController.swift
//  Kerrent
//
//  Created by Clinton Otten on 08/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

class DetailedCarViewController: UIViewController, UITableViewDelegate {

    var rent = Rent()
    
    @IBOutlet weak var letsGoButton: UIBarButtonItem!
    
    @IBOutlet weak var detailedTableView: UITableView!{
        didSet{
            detailedTableView.dataSource = self
            detailedTableView.delegate = self
            
            // these 2 required if using autolayout for tableviewcell
//            detailedTableView.estimatedRowHeight = 320
//            detailedTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension DetailedCarViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : DetailedCarTableViewCell = detailedTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DetailedCarTableViewCell else {
            return UITableViewCell()
        }
        
        cell.carImage.image = rent.image
        cell.carName.text = rent.car.name
        cell.carLogo.image = rent.image
        cell.locationLabel.text = rent.location
        cell.dateStartLabel.text = rent.dateStart
        cell.dateEndLabel.text = rent.dateEnd
        cell.priceLabel.text = rent.price
        
        cell.capacityLabel.text = "\(rent.car.capacity) PAX"
        cell.yearLabel.text = "\(rent.car.year)"
        cell.transmissionLabel.text = rent.car.transmission
        cell.typeLabel.text = rent.car.type
        cell.colorLabel.text = rent.car.color
        cell.makeLabel.text = rent.car.manufacturer
        
        return cell
    }
        
        
    
}


