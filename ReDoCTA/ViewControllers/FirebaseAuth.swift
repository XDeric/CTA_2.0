//
//  FirebaseAuth.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    private init() {}
    static let manager = FirebaseAuthService()
    
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    func createNewUser(withEmail: String, password: String, completion: @escaping (Result<User,Error>) -> Void) {
        auth.createUser(withEmail: withEmail, password: password) { (result, error) in
            if let createdUser = result?.user {
                completion(.success(createdUser))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func loginUser(withEmail: String, password: String, completion: @escaping (Result<User, Error>)-> Void) {
        auth.signIn(withEmail: withEmail, password: password) { (result, error) in
            if let user = result?.user{
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    
    func updateUserFields(userName: String? = nil,photoURL: URL? = nil, completion: @escaping (Result<(),Error>) -> ()){
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        if let userName = userName {
            changeRequest?.displayName = userName
        }
        if let photoURL = photoURL {
            changeRequest?.photoURL = photoURL
        }
        changeRequest?.commitChanges(completion: { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }
    
    func updateUserName(userName: String) {
        let request = auth.currentUser?.createProfileChangeRequest()
        request?.displayName = userName
        request?.commitChanges(completion: { (error) in
            if let error = error {
                print("error changing userName \(error)")
            }
            
        })
    }
    
}
