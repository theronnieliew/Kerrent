import UIKit
import Alamofire
import SwiftyJSON

class ListCarViewController: UIViewController {
    
    let manufacturerArray = ["Proton","Perodua","Toyota","Honda","Nissan","Mazda","Hyundai","Kia","Mercedes Benz", "BMW", "Audi", "Lexus", "Volkswagen", "Ford", "Mitsubishi"]
    let odometerArray = ["0 - 130km","130km -"]
    var transmissionArray : [String] = []
    var colorArray : [String] = ["Red", "Yellow", "Green", "Blue", "Gold", "White", "Black", "Grey", "Silver", "Other"]
    
    var carArray : [String] = []
    var yearArray : [Int] = []
    var styleArray : [String] = []
    var styleIDArray : [Int] = []
    var carBodyType : [String] = []
    
    @IBOutlet var labelCollection: [UILabel]!
    @IBOutlet var buttonCollection: [UIButton]!
    
    var arrayTracker = 0
    var pickerIntTracker = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadCar(carType : String){
        let formattedString = carType.replacingOccurrences(of: " ", with: "")
        
        Alamofire.request("https://api.edmunds.com/api/vehicle/v2/\(formattedString)/models?fmt=json&api_key=cge5bqqabtzbcevgr567jqdb").responseJSON(completionHandler: {(response) in
            switch response.result{
            case .success(let resposeValue) :
                let json = JSON(resposeValue)
                
                if let dictionary = json.rawValue as? [String:AnyObject] {
                    let models = dictionary["models"] as! [NSDictionary]
                    for model in models{
                        let carName = model["name"] as! String
                        self.carArray.append(carName)
                    }
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        })
        print("Done Retrieving for \(carType)")
    }
    
    func loadCarYear(carType : String, carModel : String){
        let formattedType = carType.replacingOccurrences(of: " ", with: "")
        let formattedString = carModel.replacingOccurrences(of: " ", with: "")
        
        Alamofire.request("https://api.edmunds.com/api/vehicle/v2/\(formattedType)/\(formattedString)?fmt=json&api_key=cge5bqqabtzbcevgr567jqdb").responseJSON(completionHandler: {(response) in
            switch response.result{
            case .success(let resposeValue) :
                let json = JSON(resposeValue)
                
                if let dictionary = json.rawValue as? [String:AnyObject] {
                    let years = dictionary["years"] as! [NSDictionary]
                    for year in years{
                        let carYear = year["year"] as! Int
                        self.yearArray.append(carYear)
                    }
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        })
        print("Done Retrieving year for \(carModel)")
    }
    
    func loadCarStyles(carType : String, carModel : String, year : String){
        let formattedType = carType.replacingOccurrences(of: " ", with: "")
        let formattedModel = carModel.replacingOccurrences(of: " ", with: "")

        Alamofire.request("https://api.edmunds.com/api/vehicle/v2/\(formattedType)/\(formattedModel)/\(year)/?fmt=json&api_key=cge5bqqabtzbcevgr567jqdb").responseJSON(completionHandler: {(response) in
            switch response.result{
            case .success(let resposeValue) :
                let json = JSON(resposeValue)

                if let dictionary = json.rawValue as? [String:AnyObject] {
                    let styles = dictionary["styles"] as! [NSDictionary]
                    for style in styles{
//                        let submodel = style["submodel"] as! NSDictionary
                        let styleName = style["name"] as! String
                        self.styleArray.append(styleName)
                        
                        let styleID = style["id"] as! Int
                        self.styleIDArray.append(styleID)
                    }
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        })
        print("Done Retrieving style for \(carModel) for year \(year)")
    }
    
    func loadCarBoyType(styleID : Int){
        Alamofire.request("https://api.edmunds.com/api/vehicle/v2/styles/\(styleID)?fmt=json&api_key=cge5bqqabtzbcevgr567jqdb").responseJSON(completionHandler: {(response) in
            switch response.result{
            case .success(let resposeValue) :
                let json = JSON(resposeValue)
                
                if let dictionary = json.rawValue as? [String:AnyObject] {
                    let submodel = dictionary["submodel"] as! NSDictionary

                    let body = submodel["body"] as! String
                    print("STYLE ID : \(styleID)")
                    print("CAR BODY : \(body)")
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        })
    }
    
    func loadCarTransmission(styleID : Int){
        Alamofire.request("https://api.edmunds.com/api/vehicle/v2/styles/\(styleID)/transmissions?fmt=json&api_key=cge5bqqabtzbcevgr567jqdb").responseJSON(completionHandler: {(response) in
            switch response.result{
            case .success(let resposeValue) :
                let json = JSON(resposeValue)
                
                if let dictionary = json.rawValue as? [String:AnyObject] {
                    let transmissions = dictionary["transmissions"] as! [NSDictionary]
                    
                    for transmission in transmissions{
                        let trans = transmission["transmissionType"] as! String
                        self.transmissionArray.append(trans)
                    }
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        })
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject) {
        switch sender.tag {
            case 0 :  pickerViewAlert(viewController: self, titleMsg: "Manufacturer", tagInt: sender.tag)
                self.resetModelText(index : 1)
                self.resetModelText(index : 2)
                self.resetModelText(index : 3)
                self.resetModelText(index : 4)
                self.resetModelText(index : 5)
                self.resetModelText(index : 6)
                self.disableButtons(index: 1)
                self.disableButtons(index: 2)
                self.disableButtons(index: 3)
                self.disableButtons(index: 4)
                self.disableButtons(index: 5)
                self.disableButtons(index: 6)
                self.carArray.removeAll()
            case 1 :  pickerViewAlert(viewController: self, titleMsg: "Model", tagInt: sender.tag)
                self.resetModelText(index : 2)
                self.resetModelText(index : 3)
                self.resetModelText(index : 4)
                self.resetModelText(index : 5)
                self.resetModelText(index : 6)
                self.disableButtons(index: 2)
                self.disableButtons(index: 3)
                self.disableButtons(index: 4)
                self.disableButtons(index: 5)
                self.disableButtons(index: 6)
                self.yearArray.removeAll()
            case 2 :  pickerViewAlert(viewController: self, titleMsg: "Year", tagInt: sender.tag)
                self.resetModelText(index : 3)
                self.resetModelText(index : 4)
                self.resetModelText(index : 5)
                self.resetModelText(index : 6)
                self.disableButtons(index: 3)
                self.disableButtons(index: 4)
                self.disableButtons(index: 5)
                self.disableButtons(index: 6)
                self.styleArray.removeAll()
            case 3 :  pickerViewAlert(viewController: self, titleMsg: "Style", tagInt: sender.tag)
            case 4 :  pickerViewAlert(viewController: self, titleMsg: "Odometer", tagInt: sender.tag)
            case 5 :  pickerViewAlert(viewController: self, titleMsg: "Transmission", tagInt: sender.tag)
            case 6 :  pickerViewAlert(viewController: self, titleMsg: "Color", tagInt: sender.tag)
            default : print("default")
        }
        arrayTracker = sender.tag
    }

    //!CUSTOM ALERT
    func pickerViewAlert(viewController : UIViewController, titleMsg : String, tagInt : Int) -> Void{
        let alertController = UIAlertController(title: titleMsg, message: "\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //! Create Picker Frame
        let pickerFrame = CGRect(x: 15, y: 0, width: 325, height: 200)
        let picker : UIPickerView = UIPickerView(frame: pickerFrame)
        
        //! Set picker data source and delegate
        picker.delegate = self
        picker.dataSource = self
        
        //! OK button that sets label beside to the current chosen one
        let okAction = UIAlertAction(title: "Done", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            switch tagInt{
                case 0 : self.labelCollection[0].text = self.manufacturerArray[self.pickerIntTracker]
                    self.labelCollection[0].textColor = UIColor.black
                    self.loadCar(carType: self.labelCollection[0].text!)
                    self.buttonCollection[1].isEnabled = true
                case 1 : self.labelCollection[1].text = self.carArray[self.pickerIntTracker]
                    self.labelCollection[1].textColor = UIColor.black
                    self.loadCarYear(carType: self.labelCollection[0].text!, carModel: self.labelCollection[1].text!)
                    self.buttonCollection[2].isEnabled = true
                case 2 : self.labelCollection[2].text = "\(self.yearArray[self.pickerIntTracker])"
                    self.labelCollection[2].textColor = UIColor.black
                    self.loadCarStyles(carType : self.labelCollection[0].text!, carModel: self.labelCollection[1].text!, year : self.labelCollection[2].text!)
                    self.buttonCollection[3].isEnabled = true
                case 3 : self.labelCollection[3].text = "\(self.styleArray[self.pickerIntTracker])"
                    self.loadCarBoyType(styleID: self.styleIDArray[self.pickerIntTracker])
                    self.loadCarTransmission(styleID: self.styleIDArray[self.pickerIntTracker])
                    self.labelCollection[3].textColor = UIColor.black
                    self.buttonCollection[4].isEnabled = true
                case 4 : self.labelCollection[4].text = self.odometerArray[self.pickerIntTracker]
                    self.labelCollection[4].textColor = UIColor.black
                    self.buttonCollection[5].isEnabled = true
                case 5 : self.labelCollection[5].text = self.transmissionArray[self.pickerIntTracker]
                    self.labelCollection[5].textColor = UIColor.black
                    self.buttonCollection[6].isEnabled = true
                case 6 : self.labelCollection[6].text = self.colorArray[self.pickerIntTracker]
                    self.labelCollection[6].textColor = UIColor.black
                default : print("default")
            }
            DispatchQueue.main.async {
                picker.reloadAllComponents()
            }
        })
        self.pickerIntTracker = 0
        self.arrayTracker = 0
        
        alertController.view.addSubview(picker)
        alertController.addAction(okAction)
        viewController.present(alertController, animated : true, completion:nil)
    }
    
    func resetModelText(index : Int){
        labelCollection[index].text = "Select"
        labelCollection[index].textColor = UIColor.gray
    }
    
    func disableButtons(index : Int){
        buttonCollection[index].isEnabled = false
    }
}

extension ListCarViewController : UIPickerViewDelegate{

}

extension ListCarViewController : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch arrayTracker{
            case 0 : return manufacturerArray.count
            case 1 : return carArray.count
            case 2 : return yearArray.count
            case 3 : return styleArray.count
            case 4 : return odometerArray.count
            case 5 : return transmissionArray.count
            case 6 : return colorArray.count
            default : return manufacturerArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch arrayTracker {
            case 0 : return manufacturerArray[row]
            case 1 : return carArray[row]
            case 2 : return "\(yearArray[row])"
            case 3 : return styleArray[row]
            case 4 : return odometerArray[row]
            case 5 : return transmissionArray[row]
            case 6 : return colorArray[row]
            default: return manufacturerArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerIntTracker = row
    }
}
