import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!{
        didSet{
            createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped(button:)), for: .touchUpInside)
        }
    }
    
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        self.navigationItem.title = "SIGN UP"
    }
    
    @IBAction func cancelButtonTapped(_ sender : AnyObject){
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        passwordTextField.text = ""
        emailTextField.text = ""
        
    navigationController?.popViewController(animated: true)
    }
    
    @objc func createAccountButtonTapped(button : UIButton){
        
        guard let firstname = firstNameTextField.text,
        let lastname = lastNameTextField.text,
        let email = emailTextField.text,
        let password = passwordTextField.text
            else { return }
        
        if password.characters.count < 6 {
            AlertController.alertPopUp(viewController: self, titleMsg: "Error", message: "Please assure your password contains at least 6 or more charaters", cancelMsg: "Ok")
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user,error) in
            if let authError = error{ return }
            
            guard let firUser = user else { return }
            
            self.notifySuccessfulSignUp()
            
            //!Give default icon
            let pic = "https://firebasestorage.googleapis.com/v0/b/kerrent-67d3a.appspot.com/o/defaultIcon.png?alt=media&token=aa630123-95dd-4a46-8902-315289ede35d"
            
            self.ref.child("users").child((user?.uid)!).setValue(["email" : email, "full_name" : (firstname + " " +  lastname), "profile-pic" : pic])
            
            print("Successfully registered you nigga!!")
        })
    }
    
    func notifySuccessfulSignUp(){
        
        let authSuccessNotification = Notification(name: Notification.Name(rawValue: "AuthSuccessNotification"))
        
        NotificationCenter.default.post(authSuccessNotification)
    }
}
