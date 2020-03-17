//
//  Authentication.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 15/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//
import FirebaseAuth

enum RegisterResult{
    case success
    case failed
}


protocol AuthenticationManagerProtocol {
    func getUserFromLogin(email: String, password: String, completion:@escaping (RegisterResult, String) -> Void)
    func createNewUserFromSignUp(email: String, password: String, completion:@escaping (RegisterResult, String) -> Void )
}

struct AuthenticationManager: AuthenticationManagerProtocol {
    func getUserFromLogin(email: String, password: String, completion: @escaping (RegisterResult, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (AuthDataResult, Error) in
            if Error != nil {
                completion(RegisterResult.failed, Error?.localizedDescription ?? "Please try again")
            } else{
                completion(RegisterResult.success, "Success")
            }
        }
    }
    
    func createNewUserFromSignUp(email: String, password: String, completion: @escaping (RegisterResult, String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (AuthDataResult, Error) in
            if Error != nil {

                completion(RegisterResult.failed, Error?.localizedDescription ?? "Please try again")
            } else{
                completion(RegisterResult.success, "Success")
            }
        }
    }
    

    
    
    
    
}
