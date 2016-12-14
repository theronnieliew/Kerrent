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
            
            let carID = rentDictionary["car"] as! String //! THIS RETURNS CAR ID
            
            
            self.ref.child("cars").child(carID).observe(.value, with: {(snapshot) in
                guard let carDict = snapshot.value as? [String: AnyObject] else{
                    return
                }
                print("CarDict values :\n \(carDict.values)\n\n")
                
                rent.car.name = carDict["name"] as! String
            })
            
            rent.pictureURL = rentDictionary["pics"] as! [String : String]
            let tempArray = rent.pictureURL
            for key in tempArray.values{
                self.stringURL.append(key)
            }
            
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
}

extension RentFeedViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //! GO TO DETAIL VIEW HERE
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
