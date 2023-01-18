//
//  ChangePasswordTableViewController.swift
//  e-Student
//
//  Created by Lyubomir on 16.01.23.
//

import UIKit

class ChangePasswordTableViewController: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        oldPassword.delegate = self
        newPassword.delegate = self
        confirmPassword.delegate = self
        oldPassword.isSecureTextEntry = true
        newPassword.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
        oldPassword.addIsSecureTextEntryToggleButton()
        newPassword.addIsSecureTextEntryToggleButton()
        confirmPassword.addIsSecureTextEntryToggleButton()
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        doChangePass()
    }
    
    func doChangePass() {
        guard let oldPass = oldPassword.text, let newPass = newPassword.text else {return}
        DataApiManager.changePass(idn: Model.currentStudent.idn, oldPass: oldPass, newPass: newPass)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    private var validOldPass = false
    private var newPass = ""
    private var validNewPass = false
    private var confirmPass = ""
    private var validConfirmPass = false
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
       
        if textField == oldPassword {
            let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            validOldPass = text.count >= 8
        } else if textField == newPassword {
            newPass = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            validNewPass = newPass.count >= 8
            tableView.footerView(forSection: 1)?.textLabel?.textColor = validNewPass ? .gray : .red
            tableView.footerView(forSection: 1)?.textLabel?.text = validNewPass ? "" : "Паролата трябва да бъде поне 8 символа"
            newPassword.textColor = validNewPass ? .black : .red
            if confirmPass.count >= 8 {
                tableView.footerView(forSection: 2)?.textLabel?.text = newPass == confirmPass ? "" : "Паролите не съвпадат"
                tableView.footerView(forSection: 2)?.textLabel?.textColor = .red
            }
        } else if textField == confirmPassword {
            confirmPass = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            validConfirmPass = confirmPass.count >= 8
            tableView.footerView(forSection: 2)?.textLabel?.textColor = validConfirmPass ? .gray : .red
            tableView.footerView(forSection: 2)?.textLabel?.text = validConfirmPass ? "" : "Паролата трябва да бъде поне 8 символа"
            tableView.footerView(forSection: 2)?.textLabel?.text = newPass == confirmPass ? "" : "Паролите не съвпадат"
            tableView.footerView(forSection: 2)?.textLabel?.textColor = newPass == confirmPass ? .gray : .red
        }
        
        if !confirmPass.isEmpty {
            confirmPassword.textColor = newPass == confirmPass ? .black : .red
        }
        
        saveButton.isEnabled = validOldPass && validNewPass && validConfirmPass && newPass == confirmPass
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPassword {
            newPassword.becomeFirstResponder()
        } else if textField == newPassword {
            confirmPassword.becomeFirstResponder()
        } else if textField == confirmPassword {
            confirmPassword.resignFirstResponder()
            guard validOldPass, validNewPass, validConfirmPass else { return true }
            doChangePass()
        }
        return true
    }

}
