//
//  FriendListViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 11/4/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation
import FirebaseFirestore
class FriendListViewModel{
    
    private let authenManager = AuthenticationManager()
    private let userManager = UserDetailManager()
    private let imageManager = ImageManager()
    
    var userData = UserDetail(email: "null", username: "", imageUrl: "")
    var listFriendQuery: [QueryDocumentSnapshot] = []
    var listFriendData: [QueryDocumentSnapshot] = []
    
    func addListenerToView(tavleView: UITableView){
        userManager.getFriendListener(userEmail: authenManager.checkStateLogin().1) { (result, queryDocSnapshot) in
            if result == .success {
                self.listFriendData = queryDocSnapshot
            }
            tavleView.reloadData()
        }
    }
    
    func setUserInfor(completion: @escaping (String, UIImage) -> Void){
        UserInformationSingleton.getUserInformationSingleton().getUserInformation { (userDetail, image) in
            completion(userDetail.email!,image)
        }

    }
    
//    func setUserInfor(completion: @escaping (String, UIImage) -> Void){
//        userManager.getUserInformation(email: authenManager.checkStateLogin().1) { (result, userDetail) in
//            if result == .success {
//                self.userData = userDetail
//                if self.userData.imageUrl != ""{
//                    self.imageManager.downloadImage(path: self.userData.imageUrl!) { (result, image) in
//                        completion(self.userData.email!, image)
//                    }
//                } else {
//                    completion(userDetail.email!, #imageLiteral(resourceName: "logo"))
//                }
//
//            } else{
//                completion("NUll", #imageLiteral(resourceName: "logo"))
//            }
//        }
//    }
    
    func searchBySearchBar(tableView: UITableView, text: String){
        listFriendQuery = listFriendData.filter { (querySnapshort) -> Bool in
            guard querySnapshort.documentID.lowercased().contains(text.lowercased()) else{
                return false
            }
            return true
        }
        tableView.reloadData()
    }
    
    func goToFriendChatNormal(index: Int) -> (key: String, email: String) {
        let friend = goToFriend(list: listFriendData, index: index)
        return (key: friend.data()["key"] as! String,email: friend.data()["email"] as! String)
    }
    
    func goToFriendChatQuery(index: Int) -> (key: String, email: String) {
        let friend = goToFriend(list: listFriendQuery, index: index)
        return (key: friend.data()["key"] as! String,email: friend.data()["email"] as! String)
    }
    
    func goToFriend(list: [QueryDocumentSnapshot] , index: Int) -> QueryDocumentSnapshot{
        return list[index]
        
    }
}
