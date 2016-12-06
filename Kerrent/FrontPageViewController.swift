//
//  FrontPageViewController.swift
//  Kerrent
//
//  Created by Clinton Otten on 29/11/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseDatabase

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
    }
    
    func tableDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "InstaPageTableViewCell", bundle: nil), forCellReuseIdentifier: "frontpage")
    }
}
extension FrontPageViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "frontpage", for: indexPath) as! InstaPageTableViewCell
        
        return cell

        
      
}
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row >= 1 {
     return cell1height
    } else {
      return cell2height    }
  }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      
      if indexPath.row == 0 {
        guard let tableViewCell = cell as? FrontpageTableViewCell else {return}
        
        tableViewCell.collectionViewDidLoad(dataSourceDelegate: self, forRow: indexPath.row)
        
        fetchPosts()
    
    }
  }
}

extension FrontPageViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = model[collectionView.tag][indexPath.item]
        
        
        return cell
    }
    
    
    
    func fetchPosts() {
        
        ref.child("users").child((userUID?.uid)!).observeSingleEvent(of: .value, with: {(snapshot) in
        
            if let dictionary = snapshot.value as? [String:AnyObjec] {
                
                userName.text = (dictionary["owner"] as! String?)!
                
                self.
            
            
        userName.text = user.owner
        
        @IBOutlet weak var carImage: UIImageView!
        @IBOutlet weak var userName: UILabel!
        @IBOutlet weak var userImage: UIImageView!
        
        @IBOutlet weak var menuButton: UIButton!
        @IBOutlet weak var likeButton: UIButton!
        @IBOutlet weak var commentButton: UIButton!
        @IBOutlet weak var shareButton: UIButton!
        
        @IBOutlet weak var rentButton: UIButton!
        
        var car = ""
        var dateEnd = ""
        var dateStart = ""
        var location = ""
        var owner = ""
        var ownerID = ""
        var price = ""
    }
}



