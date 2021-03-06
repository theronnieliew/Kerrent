//
//  DetailedCarViewController.swift
//  Kerrent
//
//  Created by Clinton Otten on 08/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

class DetailedCarViewController: UIViewController, UITableViewDelegate, DatePickerViewControllerDelegate {

    var rent = Rent()
    
    //@IBOutlet weak var letsGoButton: UIBarButtonItem!
    
    @IBOutlet weak var detailedTableView: UITableView!{
        didSet{
            detailedTableView.dataSource = self
            detailedTableView.delegate = self
            
            // these 2 required if using autolayout for tableviewcell
            detailedTableView.estimatedRowHeight = 770
            detailedTableView.rowHeight = UITableViewAutomaticDimension
            detailedTableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(rent.car.name)"
        
    }

    @IBAction func rentButton(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as? DatePickerViewController
        controller?.rent = rent
        controller?.delegate = self
        present(controller!, animated : true, completion : nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller : DatePickerViewController = segue.destination as! DatePickerViewController
//        controller.rent = rent
//        controller.delegate = self
    }
    
    func dismissDateView() {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailedCarViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : DetailedCarTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DetailedCarTableViewCell else {
            return UITableViewCell()
        }
        
        cell.carImage.image = rent.image
        cell.carName.text = "\(rent.car.manufacturer) \(rent.car.name)"
        //cell.carLogo.image = rent.image
        cell.locationLabel.text = rent.location
        //cell.dateStartLabel.text = rent.dateStart
        //cell.dateEndLabel.text = rent.dateEnd
        cell.priceLabel.text = "RM\(rent.price) per day"
        
        cell.capacityLabel.text = "\(rent.car.capacity) passengers"
        cell.yearLabel.text = "\(rent.car.year)"
        cell.transmissionLabel.text = rent.car.transmission
        cell.typeLabel.text = rent.car.type
        cell.colorLabel.text = rent.car.color
        //cell.makeLabel.text = rent.car.manufacturer
        
        if(rent.imageURLArray[indexPath.row] != ""){
            cell.carImage.loadImageUsingCacheWithUrlString(rent.imageURLArray[indexPath.row])
        }
        
        return cell
    }
        
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 770
//    }
    
}


