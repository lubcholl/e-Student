//
//  ViewController.swift
//  e-Student
//
//  Created by Lyubomir on 1.05.22.
//

import UIKit
import CoreData
import UserNotifications
//import XCTest

class LoginViewController: UIViewController {

    
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    let dataApiManager = DataApiManager()
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let coreDataMananger = CoreDataManager()
    let alertsManager = AlertsManager()
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        passwordTextField.addIsSecureTextEntryToggleButton()
        Model.currentUserImage = UIImage(systemName: "person.circle.fill")!
        dataApiManager.getToken { result in
            switch result {
            case .success(let token):
                self.activityIndicator.stopAnimating()
                DispatchQueue.main.async {
                    print(token)
                    
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                    self.alertsManager.singleActionAlert(controller: self, title: "Грешка", message: error.localizedDescription)
                }
            }
        }
        self.coreDataMananger.load()
        NotificationCenter.default.addObserver(self, selector: #selector(autoLogin), name: NSNotification.Name("AutoLogin"), object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                view.addGestureRecognizer(tap) // Add gesture recognizer to background view
    }

    @objc func handleTap() {
        passwordTextField.resignFirstResponder()
        pinTextField.resignFirstResponder()
        // dismiss keyoard
      }
    
    @objc func autoLogin() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.login(id: Model.currentlyLoggedInStudents[0].pin)
    }
    
    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        alertsManager.singleActionAlert(controller: self, title: "Забравена парола", message: "Моля свържете се с администратор!")
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let pin = pinTextField.text, let pass = passwordTextField.text else { return }
        guard !Model.token.isEmpty else { return }
        guard pin.count > 0, pass.count > 0 else {
            alertsManager.singleActionAlert(controller: self, title: "Внимание", message: "Pin кодът или паролата не са достатъчно дълги!")
            return
        }
        activityIndicator.startAnimating()
        dataApiManager.loginStudent(id: pin, pass: pass) { result in
            switch result {
            case .success(let student):
                DispatchQueue.main.async {
                    if student.idn.isEmpty {
                        self.alertsManager.singleActionAlert(controller: self, title: "Грешка", message: "Паролата, която сте въвели не е вярна!")
                        return
                    }
                    print(student.name)
                    self.login(id: student.idn)
                }
            case .failure(let error):
                print(error)
                self.alertsManager.singleActionAlert(controller: self, title: "Грешка", message: error.localizedDescription)
            }
        }
    }
    
    
    func login(id: String) {
        dataApiManager.fetchStudentPersonalData(id: id) { result in
            switch result {
            case .success(let student):
                Model.currentStudent = student
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.passwordTextField.text = ""
                    let homeTabBarVC = self.mainStoryboard.instantiateViewController(withIdentifier: "homeScreen") as? TabBarViewController
                    self.navigationController?.pushViewController(homeTabBarVC!, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}

