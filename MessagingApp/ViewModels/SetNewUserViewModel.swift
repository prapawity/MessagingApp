//
//  SetNewUserViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 17/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation
import UIKit

class SetNewUserViewModel {
    private let userManager = UserDetailManager()
    private let uploadImageManager = ImageManager()
    
    func saveDatatoFirebase(email: String, username: String, image: UIImage?,completion: @escaping (Result, String) -> Void){
        if image == nil {
            userManager.setupUserInformation(collection: "user_information", document: email, subCollection: "user_detail", user: UserDetail(email: email, username: username, imageUrl: "")) { (result, reason) in
                guard result == .success else {
                    return completion(.failed, reason)
                }
                return completion(.success, reason)
            }
        } else {
            uploadImageManager.uploadeUserAvatar(email: email, image: image!) { (result, reason) in
                if result == .success  {
                    self.userManager.setupUserInformation(collection: "user_information", document: email, subCollection: "user_detail", user: UserDetail(email: email, username: username, imageUrl: reason)) { (result, reason) in
                        guard result == .success else {
                            return completion(.failed, reason)
                        }
                        return completion(.success, reason)
                    }
                } else{
                    self.userManager.setupUserInformation(collection: "user_information", document: email, subCollection: "user_detail", user: UserDetail(email: email, username: username, imageUrl: "")) { (result, reason) in
                        guard result == .success else {
                            return completion(.failed, reason)
                        }
                        return completion(.success, reason)
                    }
                }
                
            }
        }
        
    }
}
