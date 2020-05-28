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
    
    private static var userInformation: (UserDetail, UIImage)?
    private static var friendList: [(QueryDocumentSnapshot, UIImage)]?
    private static var userInformationSingleton: UserInformationSingleton?
    private var friendNotifyToObserver: [NotifyObserver] = []
    
    private init(){
        setUserInformation()
    }
    
    public func getUserInformation(completion: @escaping ((UserDetail, UIImage) -> Void)) {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            if UserInformationSingleton.userInformation == nil {
                self.setUserInformation()
            } else{
                timer.invalidate()
                let userData = UserInformationSingleton.userInformation
                completion(userData!.0, userData!.1)
            }
        }
    }
    
    public func setUserInformation(){
        userManager.getUserInformation(email: authenManager.checkStateLogin().1) { (result, userDetail) in
            if result == .success {
                self.imageManager.downloadImage(path: userDetail.imageUrl!) { (resultFromDowloadImage, image) in
                    if resultFromDowloadImage == .success {
                        UserInformationSingleton.userInformation = (userDetail, image)
                    } else{
                        UserInformationSingleton.userInformation = (userDetail, #imageLiteral(resourceName: "logo"))
                    }
                    
                }
            }
        }
    }
    
    public static func getUserInformationSingleton() -> UserInformationSingleton{
        if userInformationSingleton == nil {
            userInformationSingleton = UserInformationSingleton()
        }
        return userInformationSingleton!
    }
    
    
    
    private func addFriendListener(){
        
        userManager.getFriendListener(userEmail: authenManager.checkStateLogin().1) { (result, queryDocSnapshot) in
            if result == .success {
                for i in queryDocSnapshot{
                    self.imageManager.downloadImage(path: i.data()["imageUrl"] as! String) { (resultDowloading, image) in
                        if resultDowloading == .success {
                            UserInformationSingleton.friendList?.append((i, image))
                        } else{
                            UserInformationSingleton.friendList?.append((i, #imageLiteral(resourceName: "logo")))
                        }
                    }
                }
                self.friendUpdate()
            }

        }
    }
    

}

extension UserInformationSingleton: NotifyObservee{

    
    func registerObserver(observer: NotifyObserver) {
        friendNotifyToObserver.append(observer)
    }
    
    func friendUpdate() {
        friendNotifyToObserver.map { (observer) -> Void in
            observer.friendUpdate()
        }
    }
    
    
}

