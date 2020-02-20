//
//  UpdateUserData.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import Foundation
import FirebaseFirestore


struct Post {
    let title: String
    let body: String
    let price: Double
    let id: String
    let imageURL: String
    let creatorID: String
    let dateCreated: Date?

    init(title: String, body: String, creatorID: String, price: Double, imageURL: String, dateCreated: Date? = nil) {
        self.title = title
        self.body = body
        self.imageURL = imageURL
        self.creatorID = creatorID
        self.price = price
        self.id = UUID().description
        self.dateCreated = dateCreated
    }

    init?(from dict: [String: Any], id: String) {
        guard let title = dict["title"] as? String,
            let body = dict["body"] as? String,
            let price = dict["price"] as? Double,
            let imageURL = dict["imageURL"] as? String,
            let userID = dict["creatorID"] as? String,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }

        self.title = title
        self.body = body
        self.imageURL = imageURL
        self.creatorID = userID
        self.id = id
        self.dateCreated = dateCreated
        self.price = price
    }

    var fieldsDict: [String: Any] {
        return [
            "title": self.title,
            "body": self.body,
            "creatorID": self.creatorID,
            "price": self.price,
            "imageURL": self.imageURL
        ]
    }
}
