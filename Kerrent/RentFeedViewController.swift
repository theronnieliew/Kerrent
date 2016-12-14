//
//  RentFeedViewController.swift
//  Kerrent
//
//  Created by Clinton Otten on 08/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit
import Firebase

class RentFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // FetchFeedPosts Variables
    var rent = Rent()

    // Firebase Varibales
    let userUID = FIRAuth.auth()?.currentUser
    var ref: FIRDatabaseReference!

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDidLoad()
        fetchFeedPosts()
        // Do any additional setup after loading the view.
    }

    func tableDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func fetchFeedPosts() {
        
        ref = FIRDatabase.database().reference()
        
    self.ref.child("rent").observeSingleEvent(of: .value, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]
            {
                print("DICTIONARY:\(snapshot.value)")
                
                
            }
            })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RentFeedTableViewCell
        
        return cell
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
