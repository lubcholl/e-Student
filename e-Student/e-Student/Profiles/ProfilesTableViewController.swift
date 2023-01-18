//
//  ProfilesTableViewController.swift
//  e-Student
//
//  Created by Lyubomir on 15.05.22.
//

import UIKit
import CoreData

class ProfilesTableViewController: UITableViewController {

    var imageData = Data()
    let coreDataManager = CoreDataManager()
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
    
        if editButton.title == "Редактиране" {
            tableView.setEditing(true, animated: true)
            editButton.title = "Готово"
        } else if editButton.title == "Готово" {
            tableView.setEditing(false, animated: true)
            editButton.title = "Редактиране"
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Model.coreDataStudents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfilesTableViewCell
        fetchCoreDataImage()
        // Configure the cell...
        //let student = coreDataStudents[indexPath.row]
        //cell.nameLabel.text = student.value(forKey: "name") as? String
        //cell.profileImage.image = UIImage(data: imageData)
        cell.profileImage.image = Model.currentUserImage
        cell.profileImage.layer.cornerRadius = 0.5 * cell.profileImage.bounds.size.width
        cell.profileImage.layer.masksToBounds = true
        cell.nameLabel.text = Model.currentlyLoggedInStudents[0].name

        return cell
    }
    

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        self.dismiss(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func fetchCoreDataImage() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
          
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LoggedInStudentsEntity")
        do {
          let result = try managedContext.fetch(fetchRequest)
            for _ in result {
              //imageData.append(data.value(forKey: "profileImage") as! Data)
          }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
 
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Изход") { (action, view, completion) in
            //self.items.remove(at: indexPath.row)
            //self.tbl.deleteRows(at: [indexPath], with: .automatic)
            //self.updateHeaderNumber(to: self.notifications.count)
            Model.coreDataStudents.removeAll()
            self.tableView.reloadData()
            self.coreDataManager.delete()
            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            Model.resetModel()
            completion(true)
        }

        action.backgroundColor = .systemRed
        action.image = UIImage(named: "delete")
        return action
    }
    
}
