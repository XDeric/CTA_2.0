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

struct AppUser {
    let email: String?
    let uid: String
    let dateCreated: Date?
    let chosenAPI: String?
    
    init(from user: User) {
        self.email = user.email
        self.uid = user.uid
        self.dateCreated = user.metadata.creationDate
        self.chosenAPI = user.photoURL?.absoluteString
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
    
    var fieldsDict: [String: Any] {
        return [
            "email": self.email ?? ""
        ]
    }
}
