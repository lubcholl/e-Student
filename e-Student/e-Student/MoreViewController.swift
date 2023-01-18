//
//  MoreViewController.swift
//  e-Student
//
//  Created by Lyubomir on 2.05.22.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let dataApiManager = DataApiManager()
    let alertsManager = AlertsManager()
    
    let moreOptions = ["Изучавани Дисциплини", "Заверки", "Смяна на профилна снимка", "Смяна на парола"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelDisciplineAndMarksViewController(_ segue: UIStoryboardSegue) {
      }
    
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moreOptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath)
        cell.textLabel?.text = moreOptions[indexPath.row]
        //cell. = 18
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            getDisciplines(id: Int(Model.currentStudent.idn) ?? 0)
        case 1:
            getCertifiedSemesters(id: Int(Model.currentStudent.idn) ?? 0)
        case 2:
            performSegue(withIdentifier: "changePhoto", sender: nil)
        case 3:
            performSegue(withIdentifier: "changePassword", sender: nil)
        default:
            print("default")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension MoreViewController {
    func getDisciplines(id: Int) {
        dataApiManager.fetchDisciplinesAndMarks(id: id) { result in
            switch result {
            case .success(let discNMarks):
                DispatchQueue.main.async {
                    Model.currentDisciplineAndMarks = discNMarks
                    if discNMarks.count == 0 {
                        self.alertsManager.singleActionAlert(controller: self, title: "Съобщение", message: "Нямате изучавани дисциплини и оценки.")
                    } else {
                        let studiedDiciplinesVC = self.mainStoryboard.instantiateViewController(withIdentifier: "studiedDiciplines") as? StudiedDisciplinesCollectionViewController
                        self.navigationController?.pushViewController(studiedDiciplinesVC!, animated: true)
                    }
                }
            case .failure(let error):
                print(error)
                self.alertsManager.singleActionAlert(controller: self, title: "Грешка", message: error.localizedDescription)
            }
            
        }
    }

    func getCertifiedSemesters(id: Int) {
        dataApiManager.fetchCertifiedSemesters(id: id) { result in
            switch result {
            case .success(let certifiedSemesters):
                DispatchQueue.main.async {
                    Model.currentCertifiedSemesters = certifiedSemesters
                    if certifiedSemesters.count == 0 {
                        self.alertsManager.singleActionAlert(controller: self, title: "Съобщение", message: "Нямате заверени семестри.")
                    } else {
                        let certifiedSemestersTVC = self.storyboard?.instantiateViewController(withIdentifier: "certifiedSemestersTVC") as? certifiedSemsetersTableViewController
                        self.navigationController?.pushViewController(certifiedSemestersTVC!, animated: true)
                    }
                    
                }
            case .failure(let error):
                print(error)
                self.alertsManager.singleActionAlert(controller: self, title: "Грешка", message: error.localizedDescription)
            }
        }
    }
}
