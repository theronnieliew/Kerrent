import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!{
        didSet{
            createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped(button:)), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonTapped(_ sender : AnyObject){
        usernameTextField.text = ""
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    @objc func createAccountButtonTapped(button : UIButton){
        
        guard let username = usernameTextField.text,
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
            
            print("Successfully registered you nigga!!")
        })
    }
    
    func notifySuccessfulSignUp(){
        
        let authSuccessNotification = Notification(name: Notification.Name(rawValue: "AuthSuccessNotification"))
        
        NotificationCenter.default.post(authSuccessNotification)
    }
}
