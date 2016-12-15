//
//  RentFeedViewController.swift
//  Kerrent
//
//  Created by Clinton Otten on 08/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit
import Firebase

class RentFeedViewController: UIViewController {
    
    // FetchFeedPosts Variables
    var rentArray : [Rent] = []
    var stringURL : [String] = []

    // Firebase Varibales
    let userUID = FIRAuth.auth()?.currentUser
    var ref: FIRDatabaseReference!

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 375
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        fetchFeedPosts()    }
    
    func fetchFeedPosts() {
        ref.child("rent").observe(.childAdded, with: {(snapshot) in
            guard let rentDictionary = snapshot.value as? [String: AnyObject] else{
                return
            }
            print("Dictionary values :\n \(rentDictionary.values)\n\n")
            
            let rent = Rent()
            rent.price = rentDictionary["price"] as! String
            rent.dateStart = rentDictionary["AVDateStart"] as! String
            rent.dateEnd = rentDictionary["AVDateEnd"] as! String
            rent.location = rentDictionary["location"] as! String
            rent.ownerID = rentDictionary["ownerID"] as! String
            
            let tempArray = rentDictionary["pics"] as! [String : String]
            
            for key in tempArray.values{
                self.stringURL.append(key)
                rent.imageURLArray.append(key)
            }
            
            let carID = rentDictionary["car"] as! String //! THIS RETURNS CAR ID
            self.ref.child("cars").child(carID).observe(.value, with: {(snapshot) in
                guard let carDict = snapshot.value as? [String: AnyObject] else{
                    return
                }
                print("CarDict values :\n \(carDict.values)\n\n")
                
                rent.car.name = carDict["name"] as! String
                rent.car.color = carDict["color"] as! String
                rent.car.capacity = carDict["capacity"] as! Int
                rent.car.manufacturer = carDict["manufacturer"] as! String
                rent.car.transmission = carDict["transmission"] as! String
                rent.car.type = carDict["type"] as! String
                rent.car.year = carDict["year"] as! Int
            })
            
            self.rentArray.append(rent)
            self.tableView.reloadData()
        })
    }
    
    func fetchCar(){
        ref.child("cars").child("Car1").observeSingleEvent(of: .value, with: {(snapshot) in
            guard let carDict = snapshot.value as? [String: AnyObject] else{
                return
            }
            print("CarDict values :\n \(carDict.values)\n\n")
            
            let car = Car()
            car.name = carDict["name"] as! String
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailViewController"){
            let selectedIndexPath = tableView.indexPathForSelectedRow
            let controller : DetailedCarViewController = segue.destination as! DetailedCarViewController
            controller.rent = rentArray[(selectedIndexPath?.row)!]
        }
    }
}

extension RentFeedViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "detailViewController", sender: self)
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
//        vc.rent = rentArray[indexPath.row]
//        self.present(vc, animated: true, completion: nil)
    }
}

extension RentFeedViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : RentFeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RentFeedTableViewCell else {
            return UITableViewCell()
        }
        
        let rent = rentArray[indexPath.row]
        
        cell.priceLabel.text = rent.price
        cell.carNameLabel.text = rent.car.name
        if(stringURL[indexPath.row] != ""){
            cell.carImage.loadImageUsingCacheWithUrlString(stringURL[indexPath.row])
        }
        
        return cell
    }
}
