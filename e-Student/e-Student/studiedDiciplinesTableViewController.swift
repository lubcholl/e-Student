//
//  studiedDiciplinesTableViewController.swift
//  e-Student
//
//  Created by Lyubomir on 3.05.22.
//

import UIKit

class studiedDiciplinesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Model.currentDisciplineAndMarks[Model.currentDisciplineAndMarks.count - 1].semes
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Model.currentDisciplineAndMarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "disciplineCell", for: indexPath)
        cell.textLabel?.text = Model.currentDisciplineAndMarks[indexPath.row].discname
        cell.detailTextLabel?.text = String(Model.currentDisciplineAndMarks[indexPath.row].mark)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

}
