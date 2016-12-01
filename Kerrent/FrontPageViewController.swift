//
//  FrontPageViewController.swift
//  Kerrent
//
//  Created by Clinton Otten on 29/11/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

class FrontPageViewController: UIViewController {

    
//Variables

    @IBOutlet weak var tableView: UITableView!
  
  let cell1height : CGFloat = 80 //CGFloat
  let cell2height : CGFloat = 100 //CGFloat
  
    let model : [[UIColor]] = generateRandomData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDidLoad()
    }
    
    func tableDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension FrontPageViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell

      } else {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath)
        
        return cell
        
      }
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
}


