//
//  FriendsViewController.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 14/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FriendListViewController: UIViewController {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    let viewModel = FriendListViewModel()
    var searchStatus: Bool = false
    
    @IBOutlet weak var friendCountLabel: UILabel!
    
    @IBOutlet weak var showFriendsTableView: UITableView!
    @IBOutlet weak var searchFriendBar: UISearchBar!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        // Do any additional setup after loading the view.
        
    }
    
    private func viewSetup(){
        tabBarController?.title = "Friends"
        addAddFriendBtn()
        showFriendsTableView.register(UINib(nibName: "FriendListCell", bundle: nil), forCellReuseIdentifier: "friendListCell")
        showFriendsTableView.delegate = self
        showFriendsTableView.dataSource = self
        viewModel.setUserInfor { (name, image) in
            self.nameLabel.text = name
            self.avatarImage.image = image
        }
        viewModel.addListenerToView(tableView: showFriendsTableView)
    }
    
    @objc private func toAddFriend(){
        performSegue(withIdentifier: "toAddFriend", sender: nil)
    }
    private func addAddFriendBtn(){
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toAddFriend))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatFromFriend"{
            if let destination = segue.destination as? ChatRoomViewController{
                let data = (sender as? (String, String))!
                destination.viewModel = ChatRoomViewModel(key: data.0, email: data.1)
            }
        }
    }
}

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchStatus = false
            showFriendsTableView.reloadData()
        } else {
            searchStatus = true
            viewModel.searchBySearchBar(tableView: showFriendsTableView, text: searchText)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendCountLabel.text = "Friends: \(searchStatus == false ? viewModel.listFriendData.count: viewModel.listFriendQuery.count)"
        return searchStatus == false ? viewModel.listFriendData.count : viewModel.listFriendQuery.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = showFriendsTableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! FriendListCell
        
        searchStatus == false ? cell.setCell(email: viewModel.listFriendData[indexPath.row].0.documentID,image: viewModel.listFriendData[indexPath.row].1) : cell.setCell(email: viewModel.listFriendQuery[indexPath.row].0.documentID, image: viewModel.listFriendQuery[indexPath.row].1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friendToGo = searchStatus == true ? viewModel.goToFriendChatQuery(index: indexPath.row): viewModel.goToFriendChatNormal(index: indexPath.row)
        performSegue(withIdentifier: "toChatFromFriend", sender: friendToGo)
    }
    
}

