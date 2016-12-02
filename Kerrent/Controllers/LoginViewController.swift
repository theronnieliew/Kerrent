import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.addTarget(self, action: #selector(loginButtonTapped(button:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookLoginButton.delegate = self
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

extension LoginViewController : FBSDKLoginButtonDelegate{
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error!.localizedDescription)
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential, completion: {(user,error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            print("User logged in with FB")
            
            self.notifySuccessLogin()
        })
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
        print("User has logged out of Facebook")
    }
}
