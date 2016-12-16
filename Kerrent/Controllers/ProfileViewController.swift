import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePicImgView: UIImageView!{
        didSet{
            profilePicImgView.layer.cornerRadius = profilePicImgView.frame.size.width / 2
            profilePicImgView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var historyTableView: UITableView! {
        didSet{
            historyTableView.dataSource = self
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user = User()
    let userUID = FIRAuth.auth()?.currentUser
    
    var ref: FIRDatabaseReference!
    
    //var historyArray = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
      fetchUser()
    }
    
    func fetchUser() {
        ref.child("users").child((userUID?.uid)!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.user.name = (dictionary["full_name"] as! String?)!
//                self.user.email = (dictionary["email"] as! String?)!
//                self.user.number = (dictionary["number"] as! String?)!
//                self.user.ic = (dictionary["IC"] as! String?)!
                self.user.profilePic = (dictionary["profile-pic"] as? String)!
//                self.user.facebookID = (dictionary["facebookID"] as! String?)!
                
                self.nameLabel.text = self.user.name
                self.emailLabel.text = self.user.email
//                self.phoneNumberLabel.text = self.user.number
                
                let url = URL(string: self.user.profilePic)
                let data = try? Data(contentsOf: url!)
                self.profilePicImgView.image = UIImage(data: data!)
            }
        })
    }
    
//    func fetchHistory() {
//        
//        ref.child("history")
    
    @IBAction func logOutButton(_ sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "RegisterStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "StartingViewController")
        self.view.window?.rootViewController = controller
    }
}

extension ProfileViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryTableViewCell
        
//        cell.
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
//        return historyArray.count
    }
}
