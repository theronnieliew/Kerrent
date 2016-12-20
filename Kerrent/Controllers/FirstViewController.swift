//
//  FirstViewController.swift
//  Kerrent
//
//  Created by Clinton Otten on 15/12/2016.
//  Copyright © 2016 Panda^4. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.roundcorners()
        }
    }
    @IBOutlet weak var signupButton: UIButton!{
        didSet{
            signupButton.roundcorners()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .default
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
