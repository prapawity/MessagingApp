//
//  FriendListViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 11/4/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit
import FirebaseFirestore
class FriendListViewModel{
    
    private let authenManager = AuthenticationManager()
    private let userManager = UserDetailManager()
    private let imageManager = ImageManager()
    private var tableView: UITableView?
    
    var userData: (UserDetail, UIImage)?
    var listFriendQuery: [(QueryDocumentSnapshot, UIImage)] = []
    var listFriendData: [(QueryDocumentSnapshot, UIImage)] = []
    
    init() {
        UserInformationSingleton.getInstance().registerUserObserver(observer: self)
        UserInformationSingleton.getInstance().registerFriendObserver(observer: self)
    }
    
    func addListenerToView(tableView: UITableView){
        
        listFriendData = UserInformationSingleton.getFriendList()
        self.tableView = tableView
        
    }
    
    func setUserInfor(completion: @escaping (String, UIImage) -> Void){
        
        UserInformationSingleton.getInstance().getUserInformation { (userDetail, image) in
            completion(userDetail.email!,image)
        }

    }
    
    func searchBySearchBar(tableView: UITableView, text: String){
        listFriendQuery = listFriendData.filter { (querySnapshort) -> Bool in
            guard querySnapshort.0.documentID.lowercased().contains(text.lowercased()) else{
                return false
            }
            return true
        }
        tableView.reloadData()
    }
    
    func goToFriendChatNormal(index: Int) -> (key: String, email: String) {
        let friend = goToFriend(list: listFriendData, index: index)
        return (key: friend.0.data()["key"] as! String,email: friend.0.data()["email"] as! String)
    }
    
    func goToFriendChatQuery(index: Int) -> (key: String, email: String) {
        let friend = goToFriend(list: listFriendQuery, index: index)
        return (key: friend.0.data()["key"] as! String,email: friend.0.data()["email"] as! String)
    }
    
    func goToFriend(list: [(QueryDocumentSnapshot, UIImage)] , index: Int) -> (QueryDocumentSnapshot, UIImage){
        return list[index]
        
    }
}
extension FriendListViewModel: NotifyObserver{
    
    func friendUpdate(updateData: [(QueryDocumentSnapshot, UIImage)]) {
        
        listFriendData = updateData.sorted(by: { (first, second) -> Bool in
            return first.0.data()["email"] as! String > second.0.data()["email"] as! String ? false : true
        })
        
        tableView?.reloadData()

    }
    
    func userInformationUpdate(newInformation: (UserDetail, UIImage)) {
        userData = newInformation
    }
    
    
}
