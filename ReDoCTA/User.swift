//
//  User.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum API: String {
    case rijks = "rijks"
    case ticket = "ticket"
}

extension User {
    func getApi() -> String{
        return "test"
    }
}

class AppUser {
    let email: String?
    let uid: String
    let dateCreated: Date?
    var chosenAPI: String?
//    
    init(from user: User) {
        self.email = user.email
        self.uid = user.uid
        self.dateCreated = user.metadata.creationDate
        self.chosenAPI = user.photoURL?.absoluteString //user.getApi() // photoURL?.absoluteString
    }
    
    
    
    init?(from dict: [String: Any], id: String) {
        guard let email = dict["email"] as? String,
            let chosenAPI = dict["chosenAPI"] as? String,
            //MARK: TODO - extend Date to convert from Timestamp?
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }
        
        self.email = email
        self.uid = id
        self.dateCreated = dateCreated
        self.chosenAPI = chosenAPI
    }
    
//    static func getApi(api: API)-> API{
//        switch api {
//        case .rijks:
//            return API.rijks
//        case .ticket:
//            return API.ticket
//        default:
//            return API.rijks
//        }
//    }
    
    var fieldsDict: [String: Any] {
        return [
            "email": self.email ?? ""
        ]
    }
}
