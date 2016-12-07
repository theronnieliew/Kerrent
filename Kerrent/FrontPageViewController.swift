//
//  FrontPageViewController.swift
//  Kerrent
//
//  Created by Clinton Otten on 29/11/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FrontPageViewController: UIViewController {

    
//Variables

    @IBOutlet weak var tableView: UITableView!
  
    let cell1height : CGFloat = 430 //CGFloat
    let cell2height : CGFloat = 430 //CGFloat
  
    let model : [[UIColor]] = generateRandomData()
    
    var user = Rent()
    
    let userUID = FIRAuth.auth()?.currentUser
    
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDidLoad()
        
        ref = FIRDatabase.database().reference()
    
        fetchPosts()
    }
    
    func tableDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "InstaPageTableViewCell", bundle: nil), forCellReuseIdentifier: "frontpage")
    }
    
    
    func fetchPosts() {
        
        self.ref.child("rent").child("101").observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                print("SNAPSHOT : \(snapshot)")
                
                self.user.car = (dictionary["car"] as! String?)!
                
                self.user.dateEnd = (dictionary["dateEnd"] as! String?)!
                
                self.user.dateStart = (dictionary["dateStart"] as! String?)!
                
                self.user.location = (dictionary["location"] as! String?)!
                
                self.user.owner = (dictionary["owner"] as! String?)!
                
                self.user.ownerID = (dictionary["ownerID"] as! String?)!
                
                self.user.price = (dictionary["price"] as! String?)!
                
                let pic = (dictionary["pics"])!
                print("\(pic)")
                
                self.user.pic = (pic["pic1"] as! String?)!
                print("\(self.user.pic)")
                
                let url = URL(string: self.user.pic)
                let data = try? Data(contentsOf: url!)

                self.user.image = UIImage(data: data!)!
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        })
    }
}
extension FrontPageViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "frontpage", for: indexPath) as! InstaPageTableViewCell
        
        cell.userName.text = user.owner
        cell.rentButton.titleLabel?.text = user.price
        cell.carImage.image = user.image

//        @IBOutlet weak var carImage: UIImageView!
//        @IBOutlet weak var userName: UILabel!
//        @IBOutlet weak var userImage: UIImageView!
//        
//        @IBOutlet weak var menuButton: UIButton!
//        @IBOutlet weak var likeButton: UIButton!
//        @IBOutlet weak var commentButton: UIButton!
//        @IBOutlet weak var shareButton: UIButton!
//        
//        @IBOutlet weak var rentButton: UIButton!
        
        return cell
      
}
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row >= 1 {
     return cell1height
    } else {
      return cell2height    }
  }

}
//extension FrontPageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return model[collectionView.tag].count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        
//        cell.backgroundColor = model[collectionView.tag][indexPath.item]
//        
//        
//        return cell
//    }
//    
//    
//    
//}



