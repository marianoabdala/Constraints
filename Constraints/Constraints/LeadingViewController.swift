import UIKit

class LeadingViewController: UIViewController {

    enum Position: String {
        
        case Left8, Left40
        
        static let all: [Position] = [.Left8, .Left40]
        
        func constraintConstant() -> CGFloat {
            
            switch self {
                
            case .Left8:
                
                return 8
                
            case .Left40:
                
                return 40
            }
        }
    }

    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var animatedSwitch: UISwitch!
    @IBOutlet weak var positionPicker: UIPickerView!
    
    @IBOutlet weak var positionLabelLeadingConstraint: NSLayoutConstraint!
    
    var position = Position.Left8 {
        
        didSet {
            
            self.configurePosition()
        }
    }
}

extension LeadingViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Position.all.count
    }
}

extension LeadingViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Position.all[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.position = Position.all[row]
    }
}

extension LeadingViewController {
    
    private func configurePosition() {
        
        self.positionLabel.text = self.position.rawValue

        let changes = {

            self.positionLabelLeadingConstraint.constant = self.position.constraintConstant()
            
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
