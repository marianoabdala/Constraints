import UIKit

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
    
    var position = Position.Left {
        
        didSet {
            
            self.configurePosition()
        }
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
        
        self.position = Position.all[row]
    }
}

extension PrioritiesViewController {
    
    private func configurePosition() {
        
        self.positionLabel.text = self.position.rawValue
        
        let changes = {
            
            switch self.position {
                
            case .Left:
                
                self.leftPositionConstraint.priority = UILayoutPriorityDefaultHigh
                self.centerPositionConstraint.priority = UILayoutPriorityDefaultLow
                self.rightPositionConstraint.priority = UILayoutPriorityDefaultLow

            case .Center:

                self.leftPositionConstraint.priority = UILayoutPriorityDefaultLow
                self.centerPositionConstraint.priority = UILayoutPriorityDefaultHigh
                self.rightPositionConstraint.priority = UILayoutPriorityDefaultLow

            case .Right:

                self.leftPositionConstraint.priority = UILayoutPriorityDefaultLow
                self.centerPositionConstraint.priority = UILayoutPriorityDefaultLow
                self.rightPositionConstraint.priority = UILayoutPriorityDefaultHigh
            }
            
            self.view.layoutIfNeeded()
        }
        
        let completion: (Bool) -> (Void) = { _ in
            
            if let positionIndex = Position.all.index(of: self.position) {
                
                self.positionPicker.selectRow(positionIndex, inComponent: 0, animated: false)
            }
        }
        
        if self.animatedSwitch.isOn {
            
            UIView.animate(withDuration: 0.5, animations: changes, completion: completion)
            
        } else {
            
            changes()
            completion(false)
        }
    }
}
