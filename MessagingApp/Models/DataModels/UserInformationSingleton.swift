//
//  UserInformationSingleton.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 4/5/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
class UserInformationSingleton{
    
    private let authenManager = AuthenticationManager()
    private let userManager = UserDetailManager()
    private let imageManager = ImageManager()
    
    public static var userInformation: (UserDetail, UIImage)?
    private static var friendList: [(QueryDocumentSnapshot, UIImage)] = []
    private static var userInformationSingleton: UserInformationSingleton?
    
    private var friendNotifyToObserver: [NotifyObserver] = []
    private var userNotifyToObserver: [NotifyObserver] = []
    
    private init(){
        addFriendListener()
    }
    
    public func getUserInformation(completion: @escaping ((UserDetail, UIImage) -> Void)) {
        if UserInformationSingleton.userInformation == nil {
            self.setUserInformation { (data) in
                completion(data.0, data.1)
            }
        } else{
            let userData = UserInformationSingleton.userInformation
            completion(userData!.0, userData!.1)
        }
    }
    
    public func setUserInformation(completion: @escaping (((UserDetail, UIImage)) -> Void)){
        userManager.getUserInformation(email: authenManager.checkStateLogin().1) { (result, userDetail) in
            if result == .success {
                self.imageManager.downloadImage(path: userDetail.imageUrl!) { (resultFromDowloadImage, image) in
                    if resultFromDowloadImage == .success {
                        UserInformationSingleton.userInformation = (userDetail, image)
                    } else{
                        UserInformationSingleton.userInformation = (userDetail, #imageLiteral(resourceName: "logo"))
                    }
                    completion(UserInformationSingleton.userInformation!)
                    
                }
            }
        }
    }
    
    public static func getInstance() -> UserInformationSingleton{
        if userInformationSingleton == nil {
            userInformationSingleton = UserInformationSingleton()
        }
        return userInformationSingleton!
    }
    
    public static func getFriendList() -> [(QueryDocumentSnapshot, UIImage)]{
        return UserInformationSingleton.friendList
    }
    
    
    public func addFriendListener(){
        userManager.getFriendListener(userEmail: authenManager.checkStateLogin().1) { (result, queryDocSnapshot) in
            
            if result == .success {
                
                UserInformationSingleton.friendList = []
                
                queryDocSnapshot.forEach { (queryDocumentSnapshot) in
                    
                    self.userManager.getUserInformation(email: (queryDocumentSnapshot.data()["email"] as? String)!) { (result, getFriend) in
                        
                        if result == .success{
                            if getFriend.imageUrl != ""{
                                self.imageManager.downloadImage(path: getFriend.imageUrl!) { (resultDowloading, image) in
                                    if resultDowloading == .success {
                                        UserInformationSingleton.friendList.append((queryDocumentSnapshot, image))
                                    } else{
                                        UserInformationSingleton.friendList.append((queryDocumentSnapshot, #imageLiteral(resourceName: "logo")))
                                    }
                                    self.friendUpdate()

                                }
                            }else{
                                UserInformationSingleton.friendList.append((queryDocumentSnapshot, #imageLiteral(resourceName: "logo")))
                                self.friendUpdate()
                            }
                        }
                        
                        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
                            if UserInformationSingleton.friendList.count == queryDocSnapshot.count {
                                timer.invalidate()
                                self.friendUpdate()
                            }
                        }
                    }
                }

            }

        }
    }
    
    public func queryFriend(email: String) -> ((QueryDocumentSnapshot, UIImage)){
        var result: (QueryDocumentSnapshot, UIImage)?
        UserInformationSingleton.friendList.forEach { (data) in
            if data.0["email"] as! String == email{
                result = data
            }
        }
        return result!
    }
    

}

extension UserInformationSingleton: NotifyObservee{
    
    func registerUserObserver(observer: NotifyObserver) {
        userNotifyToObserver.append(observer)
    }
    
    
    func userUpdate() {
        userNotifyToObserver.forEach { (observer) in
            observer.userInformationUpdate(newInformation: UserInformationSingleton.userInformation!)
        }
        
    }
    

    
    func registerFriendObserver(observer: NotifyObserver) {
        friendNotifyToObserver.append(observer)
    }
    
    func friendUpdate() {
        friendNotifyToObserver.forEach { (observer) in
            observer.friendUpdate(updateData: UserInformationSingleton.friendList)
        }
    }
    
    
    
    
}

