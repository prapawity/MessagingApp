//
//  ChatRoomViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 3/5/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//
import FirebaseFirestore
import UIKit
class ChatRoomViewModel{
    
    private var key: String!
    private let authenManager = AuthenticationManager()
    private let userManager = UserDetailManager()
    private let chatManager = ChatManager()
    private var chatList:[QueryDocumentSnapshot] = []
    private var userInformation: (UserDetail, UIImage)!
    private var friendInformation: (QueryDocumentSnapshot, UIImage)!
    
    var tableView: UITableView!
    
    init(key: String, email: String) {
        self.key = key
        
        UserInformationSingleton.getInstance().getUserInformation { (userDetail, image) in
            self.userInformation = (userDetail, image)
        }
        
        friendInformation = UserInformationSingleton.getInstance().queryFriend(email: email)
        
        addChatListener()
    }
    
    func addMessage(message: String){
        chatManager.sendingChatData(email: userInformation.0.email ?? authenManager.checkStateLogin().1, text: message, key: key) { (resultSendMessage) in

        }
    }
    

    func addChatListener(){
        chatManager.addChatListener(key: key) { (resultQuery, queryData) in
            self.chatList = queryData
            self.tableView.reloadData()
            let lastSec = self.tableView.numberOfSections-1
            let lastCell = self.tableView.numberOfRows(inSection: lastSec)-1
            if queryData.count > 5{
                self.tableView.scrollToRow(at: IndexPath(row: lastCell, section: lastSec), at: .bottom, animated: true)
            }
        }
    }
    
    func getUserAvatar() -> UIImage{
        return userInformation.1
    }
    
    func getFriendAvatar() -> UIImage{
        return friendInformation.1
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
        return userInformation.0.email!
    }
    
    func getFriend() -> QueryDocumentSnapshot{
        return friendInformation.0
        
    }
}
