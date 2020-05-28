//
//  ProfileViewController.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 14/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        tabBarController?.title = "Profile"
    }

}
