//
//  DataApiManager.swift
//  e-Student
//
//  Created by Lyubomir on 4.05.22.
//

import Foundation
import UIKit

class DataApiManager {
    
     func getToken(completion: @escaping (Result<Token, Error>) -> Void) {
        let url = URL(string: "http://localhost:5218/Token")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        let body = ["username": "lazarov", "password": "Lubcho1999@"]
        let bodyData = try? JSONSerialization.data(
           withJSONObject: body,
           options: .fragmentsAllowed
        )
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            } else if let data = data {
                print(String(data: data, encoding: .utf8)!)
                let newToken: String = try! JSONDecoder().decode(String.self, from: data)
                Model.token = newToken
            } else {
                if let error = error {
                    print(error)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func loginStudent(id: String, pass: String, completion: @escaping (Result<StudentLoginData, Error>) -> Void) {
        let url = URL(string: "http://localhost:5218/api/StudLogin?idn=\(id)&password=\(pass)")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.setValue("Bearer \(Model.token)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion(.failure(error))
            } else if let data = data, let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 404 {
                    let student: StudentLoginData = StudentLoginData(idn: "", name: "", plannumb: "")
                    completion(.success(student))
                    return
                }
                let student: StudentLoginData = try! JSONDecoder().decode(StudentLoginData.self, from: data)
                completion(.success(student))
            } else {
                if let error = error {
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()
        
    }
    
    func fetchStudentPersonalData(id: String, completion: @escaping (Result<Student, Error>) -> Void) {
        let url = URL(string: "http://localhost:5218/api/studentinfo?idn=\(id)")
        guard let requestUrl = url else { fatalError() }

        var request = URLRequest(url: requestUrl)
        request.setValue("Bearer \(Model.token)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print(error)
                completion(.failure(error))
            } else if let data = data {
                let student:  Student = try! JSONDecoder().decode(Student.self, from: data)
                completion(.success(student))
            } else {
                if let error = error {
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()

    }
    
    func fetchDisciplinesAndMarks(id: Int, completion: @escaping (Result<[DisciplineAndMarks], Error>) -> Void) {
        let url = URL(string: "http://localhost:5218/api/Semoc?idn=\(id)")
        guard let requestUrl = url else { fatalError() }

        var request = URLRequest(url: requestUrl)
        request.setValue("Bearer \(Model.token)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion(.failure(error))
            } else if let data = data {
                var disciplineNMarks: [DisciplineAndMarks] = []
                if !data.isEmpty {
                    disciplineNMarks = try! JSONDecoder().decode([DisciplineAndMarks].self, from: data)
                }
                completion(.success(disciplineNMarks))
            } else {
                if let error = error {
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
   
    
    func fetchCertifiedSemesters(id: Int, completion: @escaping (Result<[CertifiedSemester], Error>) -> Void) {
        let url = URL(string: "http://localhost:5218/api/Zs?idn=\(id)")
        guard let requestUrl = url else { fatalError() }

        var request = URLRequest(url: requestUrl)
        request.setValue("Bearer \(Model.token)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion(.failure(error))
            } else if let data = data, let httpResponse = response as? HTTPURLResponse {
                guard 200 ..< 300 ~= httpResponse.statusCode else {
                    print("Status code was \(httpResponse.statusCode), but expected 2xx")
                    return
                }
                
                if httpResponse.statusCode == 204 {
                    let emptyCertifiedSemesters: [CertifiedSemester] = []
                    completion(.success(emptyCertifiedSemesters))
                    return
                }
                
                let certifiedSemesters: [CertifiedSemester] = try! JSONDecoder().decode([CertifiedSemester].self, from: data)
                completion(.success(certifiedSemesters))
            } else {
                if let error = error {
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func getStudentPhoto(id: Int, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let url = URL(string: "http://localhost:5218/api/getphoto/\(id)")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.setValue("Bearer \(Model.token)",forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data){
                completion(.success(image))
            } else {
                if let error = error {
                    print(error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    static func updateProfilePhoto(idn: String, imageData: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "http://localhost:5218/api/uploadphoto")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        let body = ["idn": idn, "ImageData": imageData]
        let bodyData = try? JSONSerialization.data(
           withJSONObject: body,
           options: .fragmentsAllowed
        )
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        request.setValue("application/json",forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("Bearer \(Model.token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            } else if let _ = data {
                completion(.success(true))
            } else {
                print("error")
            }
        }
        task.resume()
    }
    
    static func changePass(idn: String, oldPass: String, newPass: String) {
        let url = URL(string: "http://localhost:5218/api/Changepass")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        let body = ["idn": idn, "oldpass": oldPass, "newpass": newPass]
        let bodyData = try? JSONSerialization.data(
           withJSONObject: body,
           options: .fragmentsAllowed
        )
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
        request.setValue("application/json",forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("Bearer \(Model.token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                // Handle HTTP request error
                print(error)
                return
                
            } else if let data = data {
              print(String(data: data, encoding: .utf8)!)
            } else {
                print("error")
                // Handle unexpected error
            }
        }
        task.resume()
    }
    
}
