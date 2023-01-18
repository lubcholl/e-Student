//
//  TabBarViewController.swift
//  e-Student
//
//  Created by Lyubomir on 4.05.22.
//

import UIKit
import CoreData

class TabBarViewController: UITabBarController {

    var dataApiManager = DataApiManager()
    let profileButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let coreDataManager = CoreDataManager()
    let alertsManager = AlertsManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.addProfileButton(image: UIImage(systemName: "person.circle.fill")!)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePhoto), name: NSNotification.Name("PhotoUpdated"), object: nil)
        updatePhoto()
        coreDataManager.save(username: "\(Model.currentStudent.firstname) \(Model.currentStudent.lastname)", pin: Model.currentStudent.idn, image: Model.currentUserImage)
        coreDataManager.load()
    }
    
    func addProfileButton(image: UIImage) {
        self.profileButton.setImage(image, for: .normal)
        self.profileButton.contentMode = .center
        self.profileButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.profileButton.addTarget(self, action: #selector (presentProfiles), for: .touchUpInside)
        self.profileButton.layer.cornerRadius = 0.5 * self.profileButton.bounds.size.width
        self.profileButton.layer.masksToBounds = true
        let rightNavBarButton = UIBarButtonItem(customView: self.profileButton)
        let currWidth = rightNavBarButton.customView?.widthAnchor.constraint(equalToConstant: 40)
        currWidth?.isActive = true
        let currHeight = rightNavBarButton.customView?.heightAnchor.constraint(equalToConstant: 40)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    
    @objc func updatePhoto() {
        dataApiManager.getStudentPhoto(id: Int(Model.currentStudent.idn) ?? 0) { result in
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    Model.currentUserImage = image
                    self.addProfileButton(image: image)
                }
            case .failure(let error):
                print(error)
                self.alertsManager.singleActionAlert(controller: self, title: "Грешка", message: error.localizedDescription)
            }
        }
    }
    
    @objc func presentProfiles() {
        print("Button tapped")
        let profilesTVC = self.mainStoryboard.instantiateViewController(withIdentifier: "profilesNavController")
        present(profilesTVC, animated: true)
    }

}
