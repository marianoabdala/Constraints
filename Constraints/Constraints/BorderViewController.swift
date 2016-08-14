import UIKit

class BorderViewController: UIViewController {
    
    enum Position: String {
        
        case Left, Right
        
        static let all: [Position] = [.Left, .Right]
    }
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var animatedSwitch: UISwitch!
    @IBOutlet weak var positionPicker: UIPickerView!
    
    @IBOutlet weak var positionLabelLeadingConstraint: NSLayoutConstraint!
    
    var position = Position.Left {
        
        didSet {
            
            self.configurePosition()
        }
    }
}

extension BorderViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Position.all.count
    }
}

extension BorderViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Position.all[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.position = Position.all[row]
    }
}

extension BorderViewController {
    
    private func configurePosition() {
        
        self.positionLabel.text = self.position.rawValue
        
        let changes = {
            
            self.positionLabelLeadingConstraint.constant = self.position == .Left ? 8.0 : self.view.bounds.width - self.positionLabel.bounds.width - 8.0
            
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
