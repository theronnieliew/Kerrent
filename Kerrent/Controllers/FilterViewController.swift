import UIKit

protocol FilterViewControllerDelegate {
    func dismissFilterView()
    func getFilters(colorArray : [String], typeArray : [String])
}

class FilterViewController: UIViewController {
    
    var filter = Filter()
    var delegate : FilterViewControllerDelegate?
    
//    var years : [Int] = []

    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet var typeButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if filter.colors.count != 0 {
            for button in colorButtons{
                if(filter.colors.contains((button.titleLabel?.text)!)){
                    button.layer.borderWidth = 2
                    button.layer.borderColor = UIColor.black.cgColor
                }
            }
        }
        
        if filter.types.count != 0 {
            for button in typeButtons{
                if(filter.types.contains((button.titleLabel?.text)!)){
                    button.layer.borderWidth = 2
                    button.layer.borderColor = UIColor.black.cgColor
                }
            }
        }
//        
//        years = Array(1990...2016)
//        print("Years : \(years)")
    }
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        if !filter.colors.contains((sender.titleLabel?.text)!){
            filter.colors.append((sender.titleLabel?.text)!)
            sender.layer.borderWidth = 2
            sender.layer.borderColor = UIColor.black.cgColor
        } else {
            filter.colors.remove(object: (sender.titleLabel?.text)!)
            sender.layer.borderWidth = 0
        }
    }
    
    @IBAction func typeButtonPressed(_ sender: UIButton) {
        if !filter.types.contains((sender.titleLabel?.text)!){
            filter.types.append((sender.titleLabel?.text)!)
            sender.layer.borderWidth = 2
            sender.layer.borderColor = UIColor.black.cgColor
        } else {
            filter.types.remove(object: (sender.titleLabel?.text)!)
            sender.layer.borderWidth = 0
        }
    }
    
    @IBAction func saveFiltersButton(_ sender: AnyObject) {
        delegate?.getFilters(colorArray: filter.colors, typeArray: filter.types)
        delegate?.dismissFilterView()
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        delegate?.dismissFilterView()
    }
}

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

