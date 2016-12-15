import UIKit

class DatePickerViewController: UIViewController {
    var rent = Rent()

    @IBOutlet var dateLabels: [UILabel]!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var daysRentingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        switch sender.tag{
            case 0 : datePickerAlert(viewController: self, titleMsg: "Start Date", tagInt : 0)
            case 1 : datePickerAlert(viewController: self, titleMsg: "End Date", tagInt : 1)
            default : print("default")
        }
    }
    
    func datePickerAlert(viewController : UIViewController, titleMsg : String, tagInt : Int){
        let alertController = UIAlertController(title: titleMsg, message: "\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        var date1 = Date()
        var date2 = Date()
        
        let datePickerFrame = CGRect(x: 15, y: 20, width: 325, height: 200)
        let picker : UIDatePicker = UIDatePicker(frame: datePickerFrame)
        picker.datePickerMode = .dateAndTime
        
         let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY ',' hh:mm"
            self.dateLabels[tagInt].text = formatter.string(from : picker.date)
            
            if tagInt == 0 { date1 = picker.date }
            if tagInt == 1 { date2 = picker.date }
            
            if(self.dateLabels[0].text != "Select" && self.dateLabels[1].text != "Select"){
                self.daysRentingLabel.text = "\(self.daysBetween(date1: date1, date2: date2))"
                
                let str = self.rent.price
                let component = str.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
                let price = component.filter({ $0 != "" }) // filter out all the empty strings in the component
                
                let rentPrice = Int(price[0])! * Int(self.daysRentingLabel.text!)!
                self.priceLabel.text = "RM \(rentPrice)"
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
