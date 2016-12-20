import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import FirebaseStorage

protocol ProfileViewControllerDelegate {
    func dismissProfileView()
}

class ProfileViewController: UIViewController {
    
    var delegate : ProfileViewControllerDelegate?

    @IBOutlet weak var profilePicImgView: UIImageView!
    
    @IBOutlet weak var profileLandscape: UIImageView!{
        didSet{
            profileLandscape.round(corners: [.bottomLeft, .bottomRight], radius: 2)
        }
    }
    @IBOutlet weak var historyTableView: UITableView! {
        didSet{
            historyTableView.dataSource = self
            historyTableView.round(corners: .allCorners, radius: 2)
            historyTableView.separatorStyle = .none
        }
    }
   // @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var nav: UINavigationBar!{
        didSet{
            nav.barTintColor = UIColor .primaryColor()
            nav.tintColor = UIColor.tertiaryColor()
            nav.isTranslucent = false
            nav.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.tertiaryColor()]
        }
    }
    
    var user = User()
    let userUID = FIRAuth.auth()?.currentUser
    var historyIDs : [String] = []
    
    var userRentHistories : [History] = []
    var ref: FIRDatabaseReference!
    let storage = FIRStorage.storage()
    var storageRef : FIRStorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        storageRef = storage.reference(forURL: "gs://kerrent-67d3a.appspot.com")
        
        fetchUser()
        fetchUserHistory()
    }
    
    func fetchUser() {
        
        ref.child("users").child((userUID?.uid)!).observeSingleEvent(of: .value , with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.user.name = (dictionary["full_name"] as! String?)!
                self.user.email = (dictionary["email"] as! String?)!
                self.user.profilePic = (dictionary["profile-pic"] as? String)!
                
//                let histories = dictionary["histories"] as! [String]
//                
//                self.fetchHistories(histories: histories)
                
                //self.nameLabel.text = self.user.name
                //self.emailLabel.text = self.user.email
                
                let url = URL(string: self.user.profilePic)
                let data = try? Data(contentsOf: url!)
                self.profilePicImgView.image = UIImage(data: data!)
                self.profilePicImgView.layer.cornerRadius = self.profilePicImgView.frame.size.width / 2
                self.profilePicImgView.clipsToBounds = true
                
                self.nav.topItem?.title = self.user.name
                
            }
        })
    }
    
    func fetchUserHistory(){
        
        ref.child("users").child((userUID?.uid)!).child("histories").observe(.childAdded , with: {(snapshot) in
            if let historyID = snapshot.value as? String {
                self.fetchHistoryDetail(historyID: historyID)
            }
        })
        
    }
    
    func fetchHistoryDetail(historyID: String) {
        
        self.ref.child("history").child(historyID).observeSingleEvent(of :.value, with: {(snapshot) in
            
            guard let historyDict = snapshot.value as? [String: AnyObject] else{
                return
            }
            
            let historyObj = History()
            historyObj.carName = historyDict["carName"] as! String
            historyObj.startDate = historyDict["rentStartDate"] as! String
            historyObj.endDate = historyDict["rentEndDate"] as! String
            historyObj.price = historyDict["price"] as! String
            
            self.userRentHistories.append(historyObj)
            self.historyTableView.reloadData()
        })
    }
    
    func fetchHistories(histories: [String] ){
        for history in histories {
            self.ref.child("history").child(history).observeSingleEvent(of :.childAdded, with: {(snapshot) in
                guard let historyDict = snapshot.value as? [String: AnyObject] else{
                    return
                }
                
                let historyObj = History()
                historyObj.carName = historyDict["carName"] as! String
                historyObj.startDate = historyDict["rentStartDate"] as! String
                historyObj.endDate = historyDict["rentEndDate"] as! String
                historyObj.price = historyDict["price"] as! String
                
                self.user.histories.append(historyObj)
                self.historyTableView.reloadData()
            })
        }
    }
    
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
    
    @IBAction func changeProfileButtonPic(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Change Photo", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) -> Void in
           self.openCameraButton()
        })
        let libraryButton = UIAlertAction(title: "Library", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            self.openLibraryFolder()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraButton)
        alertController.addAction(libraryButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated : true, completion:nil)
    }
    
    //!CAMERA SIDE OF THINGS
    func openCameraButton(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openLibraryFolder(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissProfileViewController(_ sender: AnyObject) {
        delegate?.dismissProfileView()
    }
}

extension ProfileViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.rentCarNameLabel.text = userRentHistories[indexPath.row].carName
        cell.startDateLabel.text = userRentHistories[indexPath.row].startDate
        cell.endDateLabel.text = userRentHistories[indexPath.row].endDate
        cell.rentPriceLabel.text = userRentHistories[indexPath.row].price
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRentHistories.count
    }
}

extension ProfileViewController : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePicImgView.image = selectedImage
//             Uploader.uploadImage(profilePicImgView.image!, of: FIRAuth.auth()?.currentUser)
            var data = NSData()
            data = UIImageJPEGRepresentation(profilePicImgView.image!, 0.8)! as NSData
            // set upload path
            let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("profile-pic")"
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    //store downloadURL at database
                    self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["profile-pic": downloadURL])
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController : UINavigationControllerDelegate{
    
}
