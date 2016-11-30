import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.addTarget(self, action: #selector(loginButtonTapped(button:)), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAccountButtonTapped(_ sender: AnyObject) {
        performSegue(withIdentifier: "loginToSignupSegue", sender: self)
    }
    
    @objc private func loginButtonTapped(button : UIButton){
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else{
                //! warn user to enter username/password
                return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user,error) in
            
            if let authAerror = error{
                AlertController.alertPopUp(viewController: self, titleMsg: "Error", message: "Either username or password contains an error", cancelMsg: "Ok")
                return
            }
            
            guard let firUser = user else{ return }
            
            self.notifySuccessLogin()
            
            print("Successfully logged you in nigga!")
            
            //1. Save user data if needed
            //2. Show timeline
            // else output error
        })
    }
    
    func notifySuccessLogin(){
        
        //create notification
        let authSuccessNoification = Notification(name: Notification.Name(rawValue:"AuthSuccessNotification"))
        
        // post notification
        NotificationCenter.default.post(authSuccessNoification)
    }
}
