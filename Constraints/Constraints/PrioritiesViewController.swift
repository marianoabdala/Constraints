import UIKit
import ReactiveCocoa

class PrioritiesViewController: UIViewController {
    
    enum Position: String {
        
        case Left, Center, Right
        
        static let all: [Position] = [.Left, .Center, .Right]
    }
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var animatedSwitch: UISwitch!
    @IBOutlet weak var positionPicker: UIPickerView!
    
    @IBOutlet weak var leftPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerPositionConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPositionConstraint: NSLayoutConstraint!
    
    let position = MutableProperty(Position.Left)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupBindings()
    }
}

extension PrioritiesViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Position.all.count
    }
}

extension PrioritiesViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Position.all[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.position.value = Position.all[row]
    }
}

extension PrioritiesViewController {
    
    fileprivate func setupBindings() {

        let priorityMap: (Position, Position) -> (UILayoutPriority) = { $0 == $1 ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow }
        
        self.leftPositionConstraint.rac_priority <~ self.position.producer.map { priorityMap($0, .Left) }
        self.centerPositionConstraint.rac_priority <~ self.position.producer.map { priorityMap($0, .Center) }
        self.rightPositionConstraint.rac_priority <~ self.position.producer.map { priorityMap($0, .Right) }
        
        self.position.signal.observeNext { [weak self] position in
            
            guard let strongSelf = self else { return }
            
            let changes = { strongSelf.view.layoutIfNeeded() }
            
            let completion: (Bool) -> (Void) = { [weak self] _ in
                
                guard let strongSelf = self else { return }

                if let positionIndex = Position.all.index(of: strongSelf.position.value) {

                    strongSelf.positionPicker.selectRow(positionIndex, inComponent: 0, animated: false)
                }
            }
            
            if strongSelf.animatedSwitch.isOn {

                UIView.animate(withDuration: 0.5, animations: changes, completion: completion)

            } else {

                changes()
                completion(false)
            }

        }
    }
}
