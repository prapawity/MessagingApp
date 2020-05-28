//
//  LogInViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 16/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation

class LoginViewModel {
    private let authenManager = AuthenticationManager()
    
    public func loginWithEmailandPassword(email: String, password: String, completion: @escaping (Result, String) -> Void){
        guard email != "" else {return completion(Result.failed, "Please fill Email")}
        guard password != "" else {return completion(Result.failed, "Please fill Password")}
        authenManager.getUserFromLogin(email: email, password: password) { (RegisterResult, reason) in
            completion(RegisterResult, reason)
        }
    }
    
    public func checkStateLogin() -> Bool {
        print("check", authenManager.checkStateLogin().1)
        return authenManager.checkStateLogin().0
    }
}
