//
//  Model.swift
//  e-Student
//
//  Created by Lyubomir on 5.05.22.
//

import Foundation
import UIKit
import CoreData
import NotificationCenter

let coreDataManager = CoreDataManager()

class Model {
   static var token = "" {
        didSet {
            print("Token: \(token)\n\n")
            DispatchQueue.main.async {
                let logincontroller = LoginViewController()
                let coreDataManager = CoreDataManager()
                if coreDataStudents.count != 0 {
                    coreDataManager.load()
                    logincontroller.login(id: currentlyLoggedInStudents[0].pin)
                    
                    
                }
                if currentlyLoggedInStudents.isEmpty == false {
                    NotificationCenter.default.post(name: NSNotification.Name("AutoLogin"), object: nil)
                }
            }
            
        }
    }
    static var currentStudent: Student = Student(idn: "", firstname: "", secondname: "", lastname: "", name: "", statusDescr: "", specName: "", formName: "", studyTypeName: "", email: "", vtuemail: "", fn: "", group: 0)


    static var currentDisciplineAndMarks: [DisciplineAndMarks] = []
    static var currentCertifiedSemesters: [CertifiedSemester] = []
    static var currentUserImage = UIImage(systemName: "person.circle.fill")!
    

    static var coreDataStudents: [NSManagedObject] = []

    static var currentlyLoggedInStudents: [LoggedInStudents] = []
    
    static func resetModel() {
        Model.currentStudent = Student(idn: "", firstname: "", secondname: "", lastname: "", name: "", statusDescr: "", specName: "", formName: "", studyTypeName: "", email: "", vtuemail: "", fn: "", group: 0)
        Model.currentDisciplineAndMarks = []
        Model.currentCertifiedSemesters = []
        Model.currentUserImage = UIImage(systemName: "person.circle.fill")!
        Model.coreDataStudents = []
        Model.currentlyLoggedInStudents = []
    }
}




