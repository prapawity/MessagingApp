//
//  ChatListViewController.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 14/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {

    @IBOutlet weak var showListChatTableViewCell: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        // Do any additional setup after loading the view.
    }
    
    private func viewSetup(){
        showListChatTableViewCell.delegate = self
        showListChatTableViewCell.dataSource = self
        showListChatTableViewCell.register(UINib(nibName: "ChatListCell", bundle: nil), forCellReuseIdentifier: "chatList")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ChatListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = showListChatTableViewCell.dequeueReusableCell(withIdentifier: "chatList", for: indexPath) as! ChatListCell
        return cell
    }
    
    
}
