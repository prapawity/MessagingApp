//
//  ChatManager.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 12/4/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation
import FirebaseFirestore
protocol ChatManagerProtocol {
    func sendingChatData(email: String, text: String, key: String, completion: @escaping (Result) -> Void)
}

class ChatManager: ChatManagerProtocol{
    
    private let db = Firestore.firestore()
    
    func sendingChatData(email: String, text: String, key: String, completion: @escaping (Result) -> Void) {
        db.collection("channel").document(key).collection("message").addDocument(data: ["from" : email, "message": text, "isRead": false, "timeStamp": NSDate().timeIntervalSince1970]) { (error) in
            if error != nil {
                completion(.failed)
            } else{
                self.updateTimeSending(key: key, text: text)
                completion(.success)
            }
        }
    }
    
    func updateTimeSending(key: String, text: String){
        db.collection("channel").document(key).setData(["timeStamp": NSDate().timeIntervalSince1970, "lastText": text], merge: true)
    }
    
    func addChatListener(key: String, completion: @escaping (Result,[QueryDocumentSnapshot]) -> Void) {
        db.collection("channel").document(key).collection("message").order(by: "timeStamp", descending: false).addSnapshotListener { (querySnapshort, error) in
            guard error == nil else {
                return completion(.failed,[])
            }
            completion(.success, querySnapshort!.documents)

        }
    }
    func addFriendChatListener(completion: @escaping (Result, [QueryDocumentSnapshot]) -> Void){
        db.collection("channel").order(by: "timeStamp", descending: false).addSnapshotListener { (query, error) in
            guard error == nil else {
                return completion(.failed,[])
            }
            completion(.success, query?.documents ?? [])
        }
    }
}
