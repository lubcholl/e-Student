//
//  Types.swift
//  e-Student
//
//  Created by Lyubomir on 6.05.22.
//
//1808010558
//9906251532
import Foundation
import UIKit

//MARK: Types

struct Section: Codable {
    let title: String
    let disciplines: [DisciplineAndMarks]
}

struct Token: Codable {
    let token: String
    let tokenType: String
    let expiresIn: Int
    let username: String
    let issued: String
    let expires: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case username = "userName"
        case issued = ".issued"
        case expires = ".expires"
    }
}

struct StudentLoginData: Codable {
    let idn, name, plannumb: String

    enum CodingKeys: String, CodingKey {
        case idn, name, plannumb
    }
}

struct Student: Codable {
    let idn, firstname, secondname, lastname, name, statusDescr, specName, formName, studyTypeName: String
    let email, vtuemail, fn: String
    let group: Int?
    
    //init() { }

    enum CodingKeys: String, CodingKey {
        case idn, firstname, secondname, lastname, name, email, vtuemail, fn, group
        case statusDescr = "statusdescr"
        case specName = "spec_name"
        case formName = "form_name"
        case studyTypeName = "StudyType_Name"
    }
}

struct DisciplineAndMarks: Codable, Equatable {
    let idn, nplan: String?
    let ndiscsemes: Int?
    let ndiscipl: String?
    let mark: Double
    let titul, protnumb: String?
    let linkedToOldOcid: Int?
    let discname: String?
    let semes: Int
    let ocid: Int

    enum CodingKeys: String, CodingKey {
        case idn, nplan, ndiscsemes, ndiscipl, titul, protnumb
        case linkedToOldOcid = "linked_to_old_ocid"
        case discname
        case semes
        case mark = "oc"
        case ocid
    }
    var sectionTitle: String {
        String(semes)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.semes == rhs.semes
    }
}


struct CertifiedSemester: Codable {
    let idn: String
    let sem: String
    let type, datezav: String
}


struct LoggedInStudents {
    var name: String
    var pin: String
    var profileImage: UIImage
}
