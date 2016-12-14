//
//  DetailedCarViewController.swift
//  Kerrent
//
//  Created by Clinton Otten on 08/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

class DetailedCarViewController: UIViewController {

    var rent = Rent()
    var car = Car()
    
    @IBOutlet weak var letsGoButton: UIBarButtonItem!
    
    @IBOutlet weak var detailedTableView: UITableView!{
        didSet{
            detailedTableView.dataSource = self
            detailedTableView.delegate = self
            detailedTableView.estimatedRowHeight = 770
            
            detailedTableView.rowHeight = UITableViewAutomaticDimension
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
        
        let cell : DetailedCarTableViewCell = detailedTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DetailedCarTableViewCell
        
        cell.carImage.image = rent.image
        cell.carName.text = car.name
        cell.carLogo.image = rent.image
        cell.locationLabel.text = rent.location
        cell.dateStartLabel.text = rent.dateStart
        cell.dateEndLabel.text = rent.dateEnd
        cell.priceLabel.text = rent.price
        
        cell.capacityLabel.text = ("\(car.capacity) PAX")
        cell.yearLabel.text = car.year
        cell.transmissionLabel.text = car.transmission
        cell.typeLabel.text = car.type
        cell.colorLabel.text = car.color
        cell.makeLabel.text = car.manufacturer
        
        return cell
    }
        
        
    
}

extension DetailedCarViewContoller : UITableViewDelegate {
    
}
