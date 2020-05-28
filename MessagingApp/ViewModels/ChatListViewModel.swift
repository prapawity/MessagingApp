//
//  ChatListViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 16/4/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation
import FirebaseFirestore
class ChatListViewModel{
    
    private let userManager = UserDetailManager()
    private let authenManager = AuthenticationManager()
    private let chatManager = ChatManager()
    private var friendList: [QueryDocumentSnapshot] = []
    private var friendChatList: [QueryDocumentSnapshot] = []
    private var userInformation: (UserDetail, UIImage)!
    public var tableView: UITableView!
    
    init() {
        UserInformationSingleton.getInstance().registerUserObserver(observer: self)
        setUserInformation()
    }
    
    public func getUserInformation() -> (UserDetail, UIImage){
        return userInformation
    }
    
    private func setUserInformation(){
        UserInformationSingleton.getInstance().getUserInformation { (user, image) in
            self.userInformation = (user, image)
        }
    }
    
    
    public func addFriendListener(){
        userManager.getFriendListener(userEmail: authenManager.checkStateLogin().1) { (resultFromGetFriend, qyeryDocSnapshot) in
            self.friendList = qyeryDocSnapshot
            self.addFriendChatListener()
        }
    }
    
    private func addFriendChatListener(){
        chatManager.addFriendChatListener { (result, queryDocSnapshot) in
            if result == .success {
                let filteredData = queryDocSnapshot.filter { (documentSnapshot) -> Bool in
                    let keyPerSnap = documentSnapshot.documentID
                    for i in self.friendList{
                        if i.data()["key"] as! String == keyPerSnap && documentSnapshot.data()["lastText"] as! String != ""{
                            return true
                        }
                    }
                    return false
                }
                self.friendChatList = filteredData
                self.tableView.reloadData()
            }
        }
    }
    
    public func getChatListSize() -> Int {
        return friendChatList.count
    }
    
    public func getFriendChat(index: Int) -> (QueryDocumentSnapshot){
        return friendChatList[index]
    }
    

}
extension ChatListViewModel: NotifyObserver{
    func friendUpdate(updateData: [(QueryDocumentSnapshot, UIImage)]) {
        
    }
    
    func userInformationUpdate(newInformation: (UserDetail, UIImage)) {
        userInformation = newInformation
    }
    
    
}
// รวมฐานข้อมูลที่ใช้บ่อยๆเป็น static จะได้ไม่ต้องโหลดบ่อย เช่น ลิสเพื่อน รูปเพื่อน เป็นต้น ลองสร้าง Singleton จะได้ EZ
