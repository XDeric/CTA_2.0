//
//  FirebaseService.swift
//  ReDoCTA
//
//  Created by EricM on 2/20/20.
//  Copyright © 2020 EricM. All rights reserved.
//

import Foundation
import FirebaseFirestore

fileprivate enum FireStoreCollections: String {
    case users
    case posts
    case comments
    case fave
}

enum SortingCriteria: String {
    case fromNewestToOldest = "dateCreated"
    var shouldSortDescending: Bool {
        switch self {
        case .fromNewestToOldest:
            return true
        }
    }
}

class FirestoreService {
    private init () {}
    
    static let manager = FirestoreService()
    private let db = Firestore.firestore()
    
    
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        var fields = user.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
    
    func updateCurrentUser(userName: String? = nil, photoURL: URL? = nil, completion: @escaping (Result<(), Error>) -> ()){
        guard let userId = FirebaseAuthService.manager.currentUser?.uid else {
            //MARK: TODO - handle can't get current user
            return
        }
        var updateFields = [String:Any]()
        
        if let user = userName {
            updateFields["userName"] = user
        }
        
        if let photo = photoURL {
            updateFields["photoURL"] = photo.absoluteString
        }
        
        
        //PUT request
        db.collection(FireStoreCollections.users.rawValue).document(userId).updateData(updateFields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        }
    }
    
    
    func createPost(post: Post, completion: @escaping (Result<(), Error>) -> ()) {
        var fields = post.fieldsDict
        fields["dateCreated"] = Date()
        //when creating for post need to save in document the post id
        db.collection(FireStoreCollections.posts.rawValue).document(post.id).setData(fields) { (error) in
            if let error = error {
                completion (.failure(error))
            }
            completion (.success(()))
        }
    }
    
    
    func getAllPosts(sortingCriteria: SortingCriteria? = nil, completion: @escaping (Result<[Post], Error>) -> ()) {
        let completionHandler: FIRQuerySnapshotBlock = {(snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let posts = snapshot?.documents.compactMap({ (snapshot) -> Post? in
                    let postID = snapshot.documentID
                    let post = Post(from: snapshot.data(), id: postID)
                    return post
                })
                completion(.success(posts ?? []))
            }
        }
        
        //type: Collection Reference
        let collection = db.collection(FireStoreCollections.posts.rawValue)
        //If i want to sort, or even to filter my collection, it's going to work with an instance of a different type - FIRQuery
        //collection + sort/filter settings.getDocuments
        if let sortingCriteria = sortingCriteria {
            let query = collection.order(by:sortingCriteria.rawValue, descending: sortingCriteria.shouldSortDescending)
            query.getDocuments(completion: completionHandler)
        } else {
            collection.getDocuments(completion: completionHandler)
        }
    }
    
    
    func getPosts(forUserID: String, completion: @escaping (Result<[Post], Error>) -> ()) {
        db.collection(FireStoreCollections.posts.rawValue).whereField("creatorID", isEqualTo: forUserID).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let posts = snapshot?.documents.compactMap({ (snapshot) -> Post? in
                    let postID = snapshot.documentID
                    let post = Post(from: snapshot.data(), id: postID)
                    return post
                })
                completion(.success(posts ?? []))
            }
        }
    }
    
    //MARK: delete user post
    private func reference(to collection: FireStoreCollections) -> CollectionReference{
        return db.collection(collection.rawValue)
    }
    
    func delete(postID: String, completion: @escaping (Result<(), Error>) -> ()) {
        db.collection(FireStoreCollections.posts.rawValue).document(postID).delete { (error) in
            if let error = error {
                completion (.failure(error))
            }
            completion (.success(()))
        }
    }
}
