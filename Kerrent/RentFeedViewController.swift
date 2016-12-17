//
//  RentFeedViewController.swift
//  Kerrent
//
//  Created by Clinton Otten on 08/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FirebaseHelper {
    static let auth = FIRAuth.auth()
    
    static let helper : FirebaseHelper = FirebaseHelper()
}

class RentFeedViewController: UIViewController {
    
    @IBOutlet weak var noResultsView: UIView!
    // FetchFeedPosts Variables
    var rentArray : [Rent] = []

    
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredResults = [Rent]()
    
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
        fetchFeedPosts()
    
        navigationController?.navigationBar.setBackgroundImage( UIImage (named:"GreyGradient") , for: UIBarMetrics.default)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All", "Coupe", "Sedan", "Hatchback", "MPV", "SUV"]
        searchController.searchBar.delegate = self
    }
    
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func fetchFeedPosts() {
        ref.child("rent").observe(.childAdded, with: {(snapshot) in
            guard let rentDictionary = snapshot.value as? [String: AnyObject] else{
                return
            }
            print("Dictionary values :\n \(rentDictionary.values)\n\n")
            
            let rent = Rent()
            rent.price = rentDictionary["price"] as! Int
            rent.dateStart = rentDictionary["AVDateStart"] as! String
            rent.dateEnd = rentDictionary["AVDateEnd"] as! String
            rent.location = rentDictionary["location"] as! String
            rent.ownerID = rentDictionary["ownerID"] as! String
            rent.ID = snapshot.key
            
            let tempArray = rentDictionary["pics"] as! [String : String]
            
            for key in tempArray.values{
                rent.imageURLArray.append(key)
            }
            
            let carID = rentDictionary["car"] as! String
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
    
    func filterContentForSearchText(searchText : String, scope : String = "All"){
        filteredResults = rentArray.filter{ rent in
            let typeMatch = (scope == "All") || (rent.car.type == scope)
            return typeMatch && rent.car.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailViewController"){
            let selectedIndexPath = tableView.indexPathForSelectedRow
            let controller : DetailedCarViewController = segue.destination as! DetailedCarViewController
            
            if searchController.isActive && searchController.searchBar.text != "" {
                controller.rent = filteredResults[(selectedIndexPath?.row)!]
            }else {
                controller.rent = rentArray[(selectedIndexPath?.row)!]
            }
            
        }
    }
    @IBAction func filterButtonPressed(_ sender: AnyObject) {
        //!Call filter view here!
    }
    
    @IBAction func sortButtonPressed(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Sort", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let priceLowToHighButton = UIAlertAction(title: "Price low to high", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            self.rentArray.sort { $0.price < $1.price }
            self.tableView.reloadData()
        })
        let priceHighToLowButton = UIAlertAction(title: "Price high to low", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            self.rentArray.sort { $1.price < $0.price }
            self.tableView.reloadData()
        })
        let capacityLowToHighButton = UIAlertAction(title: "Capacity low to high", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            self.rentArray.sort { $0.car.capacity < $1.car.capacity }
            self.tableView.reloadData()
        })
        let capacityHighToLowButton = UIAlertAction(title: "Capacity high to low", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            self.rentArray.sort { $1.car.capacity < $0.car.capacity }
            self.tableView.reloadData()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(priceLowToHighButton)
        alertController.addAction(priceHighToLowButton)
        alertController.addAction(capacityLowToHighButton)
        alertController.addAction(capacityHighToLowButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated : true, completion:nil)
    }
}

extension RentFeedViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailViewController", sender: self)
    }
}

extension RentFeedViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
//            if filteredResults.count <= 0{
//                print("NO RESULTS!!!")
//                noResultsView.isHidden = false
//                tableView.isHidden = true
//                if rentArray.count != 0 {
//                    noResultsView.isHidden = true
//                    tableView.isHidden = false
//                }
//            } else if filteredResults.count > 0{
//                print("THERES RESULTS!!!")
//                noResultsView.isHidden = true
//                tableView.isHidden = false
//            }
            return filteredResults.count
        }
        return rentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : RentFeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RentFeedTableViewCell else {
            return UITableViewCell()
        }
        
        let rent : Rent
        if searchController.isActive && searchController.searchBar.text != "" {
            rent = filteredResults[indexPath.row]
        } else {
            rent = rentArray[indexPath.row]
        }
        
        cell.priceLabel.text = String(rent.price)
        cell.carNameLabel.text = rent.car.name
        if(rent.imageURLArray[0] != ""){
            cell.carImage.loadImageUsingCacheWithUrlString(rent.imageURLArray[0])
        }
        
        return cell
    }
}

extension RentFeedViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope : scope)
    }
}

extension RentFeedViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
