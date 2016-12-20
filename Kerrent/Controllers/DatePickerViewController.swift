import UIKit
import Firebase
import FirebaseDatabase
import JTAppleCalendar

protocol DatePickerViewControllerDelegate {
    func dismissDateView()
}

class DatePickerViewController: UIViewController {
    var rent = Rent()
    var delegate : DatePickerViewControllerDelegate?
    var ref: FIRDatabaseReference!

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var daysRentingLabel: UILabel!
    @IBOutlet var dateButtons: [UIButton]!
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    var date1 = Date()
    var date2 = Date()
    
    let blackColor = UIColor.black
    let whiteColor = UIColor.white
    let grayColor = UIColor.gray
    
    var intTracker = 0
    //Calendar
    var aPopupContainer: PopupContainer?
    var testCalendar = Calendar(identifier: .gregorian)
    var currentDate: Date! = Date() {
        didSet {
            if intTracker == 0 { setDate(tagInt: 0) }
            if intTracker == 1 { setDate(tagInt: 1) }
        }
    }
    
    @IBOutlet weak var rentButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        locationLabel.text = self.rent.location
        rateLabel.text = "RM\(self.rent.price) daily"
        carImage.image = self.rent.image
        if(rent.imageURLArray[0] != ""){
            carImage.loadImageUsingCacheWithUrlString(rent.imageURLArray[0])
        }
//        currentDate = Date()
        self.dateButtons[0].setTitle("Start Date",for : UIControlState.normal)
        self.dateButtons[1].setTitle("End Date",for : UIControlState.normal)
    }
    
    func showCalendar() {
        let xibView = Bundle.main.loadNibNamed("CalendarPopUp", owner: nil, options: nil)?[0] as! CalendarPopUp
        xibView.calendarDelegate = self
        xibView.selected = currentDate
        PopupContainer.generatePopupWithView(xibView).show()
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
//        switch sender.tag{
//            case 0 : datePickerAlert(viewController: self, titleMsg: "Start Date", tagInt : 0)
//            case 1 : datePickerAlert(viewController: self, titleMsg: "End Date", tagInt : 1)
//            default : print("default")
//        }
        self.showCalendar()
        intTracker = sender.tag
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        delegate?.dismissDateView()
    }
    
    @IBAction func rentButton(_ sender: AnyObject) {
        ref.child("history").childByAutoId().setValue(["rentStartDate" : dateButtons[0].titleLabel!.text!, "rentEndDate" : dateButtons[1].titleLabel!.text!, "carName" : rent.car.name, "userID" : FIRAuth.auth()!.currentUser!.uid, "price" : priceLabel.text!, "rentID" : rent.ID], withCompletionBlock: {(error, result) -> Void in
            
            let alertController = UIAlertController(title: "Car Rented!", message: "You have successfully rented this car from \(self.dateButtons[0].titleLabel!.text!) until \(self.dateButtons[1].titleLabel!.text!)", preferredStyle: UIAlertControllerStyle.alert)

            let okAction = UIAlertAction(title: "Done", style: .default, handler: {(alert: UIAlertAction!) -> Void in
                self.delegate?.dismissDateView()
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated : true, completion:nil)
    
            
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
            formatter.dateFormat = "dd MMM YYYY 'at' HH:MM"
//            formatter.dateStyle = .medium
            self.dateButtons[tagInt].setTitle(formatter.string(from : picker.date),for : UIControlState.normal)
            
            if tagInt == 0 { self.date1 = picker.date }
            if tagInt == 1 { self.date2 = picker.date }
            
            if(self.dateButtons[0].titleLabel?.text != "Start Date" && self.dateButtons[1].titleLabel?.text != "Return Date"){
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
    
    func setDate(tagInt : Int) {
        
        if tagInt == 0 { self.date1 = currentDate }
        if tagInt == 1 { self.date2 = currentDate }
        
        let month = testCalendar.dateComponents([.month], from: currentDate).month!
        let weekday = testCalendar.component(.weekday, from: currentDate)
        
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        let week = DateFormatter().shortWeekdaySymbols[weekday-1]
        
        let day = testCalendar.component(.day, from: currentDate)
        
        self.dateButtons[tagInt].setTitle("\(week), " + monthName + " " + String(day),for : UIControlState.normal)
        
        if(self.dateButtons[0].titleLabel?.text != "Start Date :" && self.dateButtons[1].titleLabel?.text != "End Date :"){
            self.daysRentingLabel.text = "\(self.daysBetween(date1: self.date1, date2: self.date2))"
            let rentPrice =  self.rent.price * Int(self.daysRentingLabel.text!)!
            self.priceLabel.text = "RM \(rentPrice)"
            
            self.rentButton.isEnabled = true
        }

    }
}
extension DatePickerViewController : CalendarPopUpDelegate{
    func dateChaged(date: Date) {
        currentDate = date
    }
}
