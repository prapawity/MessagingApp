//
//  FriendsViewController.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 14/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

    @IBOutlet weak var showFriendsTableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        // Do any additional setup after loading the view.
        
    }
    
    private func viewSetup(){
        tabBarController?.title = "Friends"
        showFriendsTableView.register(UINib(nibName: "FriendListCell", bundle: nil), forCellReuseIdentifier: "friendListCell")
        showFriendsTableView.delegate = self
        showFriendsTableView.dataSource = self
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

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = showFriendsTableView.dequeueReusableCell(withIdentifier: "friendListCell", for: indexPath) as! FriendListCell
        
        
        return cell
    }
    
    
}
