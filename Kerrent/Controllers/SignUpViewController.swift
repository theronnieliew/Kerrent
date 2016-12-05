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
        passwordTextField.text = ""
        emailTextField.text = ""
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
            
            self.ref.child("users").child((user?.uid)!).setValue(["email" : email, "full_name" : (firstname + " " +  lastname)])
            
            print("Successfully registered you nigga!!")
        })
    }
    
    func notifySuccessfulSignUp(){
        
        let authSuccessNotification = Notification(name: Notification.Name(rawValue: "AuthSuccessNotification"))
        
        NotificationCenter.default.post(authSuccessNotification)
    }
}
