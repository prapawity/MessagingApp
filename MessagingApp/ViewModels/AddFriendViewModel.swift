//
//  AddFriendViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 10/4/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//
import UIKit
class AddFriendViewModel {
    
    private let userManager = UserDetailManager()
    private let authenManager = AuthenticationManager()
    private let imageManager = ImageManager()
    
    func findingFriendFromViewModel(email:String, completion: @escaping (Result, UserDetail, UIImage) -> Void){
        userManager.getUserInformation(email: email) { (resultType, userData) in
            guard resultType == .success else {
                return completion(.failed, userData, #imageLiteral(resourceName: "logo"))
            }
            if userData.imageUrl != "" {
                self.imageManager.downloadImage(path: userData.imageUrl!) { (resultTypeError, image) in
                    completion(.success, userData, image)
                }
            } else {
                completion(.success, userData, #imageLiteral(resourceName: "logo"))
            }

        }
        
    }
    
    func isFriend(friendEmail:String,completion: @escaping (Result) -> Void) {
        guard friendEmail != authenManager.checkStateLogin().1 else{
            return completion(.success)
        }
        userManager.getFriendFromList(userEmail: authenManager.checkStateLogin().1, friendEmail: friendEmail) { (result) in
            
            completion(result)
        }
    }
    
    func addFriendFromViewModel(friendEmail:String,completion: @escaping (Result) -> Void) {
        userManager.addFriend(userEmail: authenManager.checkStateLogin().1, friendEmail: friendEmail) { (resultType) in
            completion(resultType)
        }
        
    }
    
}
