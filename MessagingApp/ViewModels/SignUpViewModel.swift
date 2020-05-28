//
//  SignUpViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 15/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation


class SignUpViewModel {
    
    private let authenManager = AuthenticationManager()
    private let userManager = UserDetailManager()
    
    public func signupNewUserWithEmailandPassword(email: String, password: String, conPassword: String, completion: @escaping (Result, String) -> Void){
        guard email != "" else {return completion(Result.failed, "Please fill Email")}
        guard password != "" else {return completion(Result.failed, "Please fill Password")}
        guard conPassword != "" else {return completion(Result.failed, "Please fill Confirm-Password")}
        guard password == conPassword else {return completion(Result.failed, "Password not match with Confirm-Password")}
        authenManager.createNewUserFromSignUp(email: email, password: password) { (RegisterResultByProtocol, reason) in

            if RegisterResultByProtocol == .success{
                self.userManager.setupUserInformation(collection: "user_information", document: email, subCollection: "user_detail", user: UserDetail(email: email, username: "", imageUrl: "")) { (result, reasonFromUserDetail) in
                    
                    guard result == .failed else{
                        return completion(.success, reasonFromUserDetail)
                    }
                    
                    completion(.failed, reasonFromUserDetail)
                }
            }else {
                completion(.failed, reason)
            }
            
        }
    }
}
