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
        
        
    }
        
        
    
}

extension DetailedCarViewContoller : UITableViewDelegate {
    
}
