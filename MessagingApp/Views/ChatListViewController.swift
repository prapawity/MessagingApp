//
//  ChatListViewController.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 14/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {
    var viewModel = ChatListViewModel()
    @IBOutlet weak var showListChatTableViewCell: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        // Do any additional setup after loading the view.
    }
    
    private func viewSetup(){
        tabBarController?.title = "Chat"
        viewModel.tableView = showListChatTableViewCell
        viewModel.addFriendListener()
        showListChatTableViewCell.delegate = self
        showListChatTableViewCell.dataSource = self
        showListChatTableViewCell.register(UINib(nibName: "ChatListCell", bundle: nil), forCellReuseIdentifier: "chatList")
    }

}
extension ChatListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getChatListSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = viewModel.getFriendChat(index: indexPath.row)
        let cell = showListChatTableViewCell.dequeueReusableCell(withIdentifier: "chatList", for: indexPath) as! ChatListCell
        return cell
    }
    
    
}
