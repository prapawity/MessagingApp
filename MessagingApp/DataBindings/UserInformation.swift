//
//  UserDetail.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 16/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage

protocol UserDetailManagerProtocol {
    func setupUserInformation(collection: String, document: String, subCollection: String, user: UserDetail, completion: @escaping (Result, String) -> Void)
    func getUserInformation(email: String, completion: @escaping (Result,UserDetail) -> Void)
    
    func addFriendToList(userEmail: String, friendEmail: String,key: String,completion: @escaping (Result) -> Void)
    
    func getFriendFromList(userEmail: String, friendEmail: String,completion: @escaping (Result) -> Void)
    
    func getFriendListener(userEmail: String, completion: @escaping (Result,[QueryDocumentSnapshot]) -> Void)
    
    func addChatChannel(userEmail: String, friendEmail: String,completion: @escaping (String) -> Void)
}


struct UserDetailManager: UserDetailManagerProtocol {
    
    
    private let db = Firestore.firestore()
    
    func addChatChannel(userEmail: String, friendEmail: String,completion: @escaping (String) -> Void) {
        db.collection("channel").addDocument(data: ["user1" : userEmail, "user2": friendEmail,"timeStamp": NSDate().timeIntervalSince1970, "lastTextFrom": "", "lastText": ""]).getDocument { (documentSnapshot, error) in
            if error == nil && ((documentSnapshot?.exists) != nil) {
                completion(documentSnapshot!.documentID)
            } else {
                completion("Null")
            }
        }
    }
    
    func addFriendToList(userEmail: String, friendEmail: String,key: String, completion: @escaping (Result) -> Void) {
        self.db.collection("user_information").document("friend_list").collection(userEmail).document(friendEmail).setData(["email" : friendEmail,"key": key]) { (errorResult) in
            if errorResult == nil{
                completion(.success)
            } else {
                completion(.failed)
            }
        }
        
    }
    
    func getFriendListener(userEmail: String, completion: @escaping (Result, [QueryDocumentSnapshot]) -> Void) {
        db.collection("user_information").document("friend_list").collection(userEmail).addSnapshotListener { (querySnapshot, error) in
            guard error != nil else{
                return completion(.success, querySnapshot!.documents)
            }
            completion(.failed, [])
        }
    }
    
    func addFriend(userEmail: String, friendEmail: String, completion: @escaping (Result) -> Void){
        addChatChannel(userEmail: userEmail, friendEmail: friendEmail) { (key) in
            self.addFriendToList(userEmail: userEmail, friendEmail: friendEmail,key:key ) { (resultType) in
                if resultType == .failed {
                    completion(resultType)
                } else{
                    self.addFriendToList(userEmail: friendEmail, friendEmail: userEmail,key: key) { (resultTypeSec) in
                        completion(resultTypeSec)
                    }
                }
            }
        }
        
    }
    
    func getFriendFromList(userEmail: String, friendEmail: String, completion: @escaping (Result) -> Void) {
        db.collection("user_information").document("friend_list").collection(userEmail).whereField("email", isEqualTo: friendEmail).getDocuments { (querySnapshort, error) in
            if (querySnapshort?.documents.isEmpty)! {
                completion(.failed)
            } else{
                completion(.success)
            }
            
        }
    }
    
    
    private func castObjToUserDetail(documentSnapshot: DocumentSnapshot) -> UserDetail {
        let dataToObj = UserDetail(email: documentSnapshot.data()!["email"] as! String, username: documentSnapshot.data()!["username"] as! String, imageUrl: documentSnapshot.data()!["imageUrl"] as! String)
        return dataToObj
    }
    
    func getUserInformation(email: String, completion: @escaping (Result, UserDetail) -> Void) {
        self.db.collection("user_information").document("user_detail").collection(email).document("profile").getDocument { (documentQueryResult, errorResult) in
            guard errorResult != nil || documentQueryResult?.data() == nil else{
                return completion(.success, self.castObjToUserDetail(documentSnapshot: documentQueryResult!))
            }
            completion(.failed, UserDetail())
        }
    }
    
    
    
    
    func setupUserInformation(collection: String, document: String, subCollection: String, user: UserDetail, completion: @escaping (Result, String) -> Void) {
        self.db.collection("user_information").document("user_detail").collection(user.email ?? "").document("profile").setData(["username" : user.username ?? "", "email" : user.email ?? "", "imageUrl" : user.imageUrl ?? ""], merge: true) { (error) in
            guard error != nil else{
                return completion(.success, "success")
            }
            completion(.failed, error?.localizedDescription ?? "Please try again")
        }
        
    }

    
    
    
    
}
