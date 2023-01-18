//
//  CoreDataManager.swift
//  e-Student
//
//  Created by Lyubomir on 16.05.22.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    func save(username: String, pin: String, image: UIImage) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let jpegImageData = image.jpegData(compressionQuality: 1.0)
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "LoggedInStudentsEntity", in: managedContext)!

        let student = NSManagedObject(entity: entity, insertInto: managedContext)
        student.setValue(username, forKeyPath: "name")
        student.setValue(pin, forKey: "pin")
        student.setValue(jpegImageData, forKeyPath: "profileImage")

        do {
          try managedContext.save()
            Model.coreDataStudents.append(student)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func load() {
        var student = Model.coreDataStudents
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LoggedInStudentsEntity")
        do {
            student = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if student.count > 0 {
            let currStudent = LoggedInStudents(name: student[0].value(forKey: "name") as! String, pin: student[0].value(forKey: "pin") as! String, profileImage: Model.currentUserImage)
            Model.currentlyLoggedInStudents.append(currStudent)
        }
    }

    
    func delete() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "LoggedInStudentsEntity")

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        let managedContext = appDelegate.persistentContainer.viewContext
        var batchDelete = NSBatchDeleteResult()
        
        do {
            batchDelete = try managedContext.execute(deleteRequest) as! NSBatchDeleteResult
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        guard let deleteResult = batchDelete.result as? [NSManagedObjectID] else { return }
        let deletedObjects: [AnyHashable: Any] = [NSDeletedObjectsKey: deleteResult]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [managedContext])
    }
}

