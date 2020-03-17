//
//  SignUpViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 15/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

class SignUpViewModel {
    private let authenManager = AuthenticationManager()
    private let db = Firestore.firestore()
    public func signupNewUserWithEmailandPassword(email: String, password: String, conPassword: String, completion: @escaping (RegisterResult, String) -> Void){
        guard email != "" else {return completion(RegisterResult.failed, "Please fill Email")}
        guard password != "" else {return completion(RegisterResult.failed, "Please fill Password")}
        guard conPassword != "" else {return completion(RegisterResult.failed, "Please fill Confirm-Password")}
        guard password == conPassword else {return completion(RegisterResult.failed, "Password not match with Confirm-Password")}
        authenManager.createNewUserFromSignUp(email: email, password: password) { (RegisterResultByProtocol, reason) in
            if RegisterResultByProtocol == .success{
                self.db.collection("user_information").document(email).collection("user_detail").addDocument(data: ["username" : "", "email" : email, "imageUrl" : ""]) { (Error) in
                    guard Error == nil else{
                        return completion(.success, reason)
                    }
                    completion(.failed, Error?.localizedDescription ?? "Please try again")
                }
            }
            completion(.failed, reason)
        }
    }
}
