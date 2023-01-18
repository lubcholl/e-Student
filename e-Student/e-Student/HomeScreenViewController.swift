//
//  HomeScreenViewController.swift
//  e-Student
//
//  Created by Lyubomir on 1.05.22.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var facNumebrLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var formLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        customizeBackground()
        showStudentDetails()
        
        // Do any additional setup after loading the view.
    }
    
    
    func showStudentDetails() {
        welcomeLabel.text = "Здравейте, \(Model.currentStudent.firstname)!"
        nameLabel.text = "\(Model.currentStudent.firstname) \(Model.currentStudent.secondname) \(Model.currentStudent.lastname)"
        pinLabel.text = "\(Model.currentStudent.studyTypeName)"
        facNumebrLabel.text = "\(Model.currentStudent.fn)"
        courseLabel.text = "\(Model.currentStudent.specName)"
        formLabel.text = "\(Model.currentStudent.formName)"
        if let group = Model.currentStudent.group {
            groupLabel.text = "\(group)"
        } else {
            groupLabel.text = "-"
        }
        emailLabel.text = "\(Model.currentStudent.vtuemail)"
        statusLabel.text = "\(Model.currentStudent.statusDescr)"
       
    }
    
    func customizeBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5).cgColor, #colorLiteral(red: 0.4639953971, green: 0.480914712, blue: 0.5765916705, alpha: 0.5).cgColor]
        gradientLayer.shouldRasterize = true
        self.view.layer.insertSublayer(gradientLayer, at: 0) 
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
