import UIKit
import Firebase
import FirebaseDatabase

protocol DatePickerViewControllerDelegate {
    func dismissDateView()
}

class DatePickerViewController: UIViewController {
    var rent = Rent()
    var delegate : DatePickerViewControllerDelegate?
    var ref: FIRDatabaseReference!

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var daysRentingLabel: UILabel!
    @IBOutlet var dateButtons: [UIButton]!
    
    var date1 = Date()
    var date2 = Date()
    
    @IBOutlet weak var rentButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        switch sender.tag{
            case 0 : datePickerAlert(viewController: self, titleMsg: "Start Date", tagInt : 0)
            case 1 : datePickerAlert(viewController: self, titleMsg: "End Date", tagInt : 1)
            default : print("default")
        }
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        delegate?.dismissDateView()
    }
    
    @IBAction func rentButton(_ sender: AnyObject) {
        ref.child("history").childByAutoId().setValue(["rentStartDate" : String(describing: date1), "rentEndDate" : String(describing: date2), "carName" : rent.car.name, "userID" : FIRAuth.auth()!.currentUser!.uid, "price" : priceLabel.text!, "rentID" : rent.ID], withCompletionBlock: {(error, result) -> Void in
            
//            self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).child("histories").setValue(result.key)
            self.delegate?.dismissDateView()
            
            
            //!CHECKIN
            self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if !snapshot.exists() { return }
                
                print("snapshot! : \(snapshot)")
                
                if let dict = snapshot.value as? Dictionary<String, AnyObject>{
                    var histories: [String] = []
                    if dict["histories"] != nil {
                        histories = dict["histories"] as! [String]
                    } else {
                        histories = []
                    }
                    
                    print("Histories! : \(histories)")
                    histories.append(result.key)
                    
                    self.ref.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["histories": histories])
                }
            })
        })
        
    }
    
    func datePickerAlert(viewController : UIViewController, titleMsg : String, tagInt : Int){
        let alertController = UIAlertController(title: titleMsg, message: "\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let datePickerFrame = CGRect(x: 15, y: 20, width: 325, height: 200)
        let picker : UIDatePicker = UIDatePicker(frame: datePickerFrame)
        picker.datePickerMode = .dateAndTime
        
         let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY ',' hh:mm"
            self.dateButtons[tagInt].setTitle(formatter.string(from : picker.date),for : UIControlState.normal)
            
            if tagInt == 0 { self.date1 = picker.date }
            if tagInt == 1 { self.date2 = picker.date }
            
            if(self.dateButtons[0].titleLabel?.text != "Start Date :" && self.dateButtons[1].titleLabel?.text != "End Date :"){
                self.daysRentingLabel.text = "\(self.daysBetween(date1: self.date1, date2: self.date2))"
                
//                let str = self.rent.price
//                let component = str.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
//                let price = component.filter({ $0 != "" }) // filter out all the empty strings in the component
                
//                let rentPrice = Int(price[0])! * Int(self.daysRentingLabel.text!)!
                let rentPrice =  self.rent.price * Int(self.daysRentingLabel.text!)!
                self.priceLabel.text = "RM \(rentPrice)"
                
                self.rentButton.isEnabled = true
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    
        alertController.view.addSubview(picker)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated : true, completion:nil)
    }
    
    func daysBetween(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: date1)
        let date2 = calendar.startOfDay(for: date2)
        
        let components = calendar.dateComponents([Calendar.Component.day], from: date1, to: date2)
        
        return components.day ?? 0
    }
}
