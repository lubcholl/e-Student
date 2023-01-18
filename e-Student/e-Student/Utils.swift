//
//  AlertsManager.swift
//  e-Student
//
//  Created by Lyubomir on 21.05.22.
//

import Foundation
import UIKit

class AlertsManager {
    
    func singleActionAlert(controller: UIViewController, title: String, message: String) {
       
            let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            dialogMessage.addAction(ok)
            controller.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    
}
extension UITextField {
    func addIsSecureTextEntryToggleButton(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "passwordEyeOpen"), for: .normal)
        button.setImage(UIImage(named: "passwordEyeClosed"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = button
        rightViewMode = .always
        button.alpha = 0.4
    }
    @objc func togglePasswordView(_ sender: UIButton) {
        isSecureTextEntry.toggle()
        sender.isSelected.toggle()
    }
}
