import Foundation
import UIKit

class AlertController{
    static func alertPopUp(viewController : UIViewController, titleMsg : String, message : String, cancelMsg : String) -> Void{
        let alertController = UIAlertController(title: titleMsg, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelButton = UIAlertAction(title: cancelMsg, style: .cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        viewController.present(alertController, animated : true, completion:nil)
    }
}

