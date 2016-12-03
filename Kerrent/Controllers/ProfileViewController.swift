import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var user = User()
    
    var userUID = "user1" //! SET TO WHATEVER UID that is currenly logged in
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        fetchUser()
    }
    
    func fetchUser() {
        ref.child("users").child(userUID).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.user.name = (dictionary["full_name"] as! String?)!
                self.user.email = (dictionary["email"] as! String?)!
                self.user.number = (dictionary["number"] as! String?)!
                self.user.ic = (dictionary["IC"] as! String?)!
                self.user.profilePic = (dictionary["profile-pic"] as! String?)!
                
                self.nameLabel.text = self.user.name
                self.emailLabel.text = self.user.email
                self.phoneNumberLabel.text = self.user.number
                
                let url = URL(string: self.user.profilePic)
                let data = try? Data(contentsOf: url!)
                self.profilePicImgView.image = UIImage(data: data!)
            }
        })
    }
    
    func populateProfileFeed(){
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneNumberLabel.text = user.number
//        profilePicImgView.image = 
    }
}
