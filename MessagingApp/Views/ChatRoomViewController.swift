//
//  ChatRoomViewController.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 15/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    var viewModel: ChatRoomViewModel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        viewModel.tableView = chatTableView
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "MyChatCell", bundle: nil), forCellReuseIdentifier: "myChatCell")
        chatTableView.register(UINib(nibName: "FriendChatCell", bundle: nil), forCellReuseIdentifier: "friendChatCell")
        self.title = (viewModel.getFriend().data()["email"] as! String)
        
    }
    
    @IBAction func sendingMessage(_ sender: Any) {
        if textField.text?.isEmpty == false{
            let message = textField.text!
            if message.replacingOccurrences(of: " ", with: "") != "" {
                viewModel.addMessage(message: message)
            }
        }
        textField.text = ""

        
        
    }
    


}
extension ChatRoomViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getChatListSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = viewModel.getchatCell(index: indexPath.row)

        if cellData.data()["from"] as! String == viewModel.getUserEmail(){
            let cell = chatTableView.dequeueReusableCell(withIdentifier: "myChatCell") as! MyChatCell
            cell.setupCell(image: viewModel.getUserAvatar(), message: cellData.data()["message"] as! String)

            return cell
        }else{
            let cell = chatTableView.dequeueReusableCell(withIdentifier: "friendChatCell") as! FriendChatCell
            cell.setupCell(image: viewModel.getFriendAvatar(), message: cellData.data()["message"] as! String)
            return cell
        }
        
    }
    
    
    
}
