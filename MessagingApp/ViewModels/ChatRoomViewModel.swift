//
//  ChatRoomViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 3/5/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation
import FirebaseFirestore
import UIKit
class ChatRoomViewModel{
    private var key: String!
    
    private let authenManager = AuthenticationManager()
    private let userManager = UserDetailManager()
    private let chatManager = ChatManager()
    private var chatList:[QueryDocumentSnapshot] = []
    private var userInformation: UserDetail!
    private var friendInformation: UserDetail!
    private var userAvatar: UIImage!
    private var friendAvatar: UIImage!
    private let imageManager = ImageManager()
    var tableView: UITableView!
    init(key: String, email: String) {
        self.key = key
        userManager.getUserInformation(email: authenManager.checkStateLogin().1) { (resultrequestUserInfo, userDetail) in
            if resultrequestUserInfo == .success {
                self.userInformation = userDetail
                self.setUserAvatar()
            }
        }
        userManager.getUserInformation(email: email) { (resultrequestUserInfo, userDetail) in
            if resultrequestUserInfo == .success {
                self.friendInformation = userDetail
                self.setFriendAvatar()
            }
        }
        
        addChatListener()
    }
    
    func addMessage(message: String){
        chatManager.sendingChatData(email: userInformation.email ?? authenManager.checkStateLogin().1, text: message, key: key) { (resultSendMessage) in

        }
    }
    
    private func setUserAvatar() {
        if userInformation != nil {
            if userInformation.imageUrl != "" || userInformation.imageUrl != nil {
                imageManager.downloadImage(path: userInformation.imageUrl!) { (resultDowloadImage, image) in
                    if resultDowloadImage == .success {
                        self.userAvatar = image
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func setFriendAvatar(){
        if friendInformation != nil {
            if friendInformation.imageUrl != "" || friendInformation.imageUrl != nil {
                imageManager.downloadImage(path: friendInformation.imageUrl!) { (resultDowloadImage, image) in
                    if resultDowloadImage == .success {
                        self.friendAvatar = image
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    func addChatListener(){
        chatManager.addChatListener(key: key) { (resultQuery, queryData) in
            self.chatList = queryData
            self.tableView.reloadData()
            let lastSec = self.tableView.numberOfSections-1
            let lastCell = self.tableView.numberOfRows(inSection: lastSec)-1
            self.tableView.scrollToRow(at: IndexPath(row: lastCell, section: lastSec), at: .bottom, animated: true)
        }
    }
    func getUserAvatar() -> UIImage{
        if userAvatar != nil{
            return userAvatar
        } else{
            if userInformation != nil && userAvatar == nil {
                setUserAvatar()
            }
            
            return #imageLiteral(resourceName: "logo")
        }
    }
    
    func getFriendAvatar() -> UIImage{
        if friendAvatar != nil{
            return friendAvatar
        } else{
            if friendInformation != nil && friendAvatar == nil {
                setFriendAvatar()
            }
            
            return #imageLiteral(resourceName: "logo")
        }
    }
    func getChatListSize() -> Int {
        return chatList.count
    }
    
    func getchatCell(index: Int) -> QueryDocumentSnapshot {
        return chatList[index]
    }
    
    func getUserEmail() -> String{
        guard userInformation != nil else {
            return self.authenManager.checkStateLogin().1
        }
        return userInformation.email!
    }
}
