//
//  UserDetail.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 17/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation

class UserDetail: Decodable {
    var email: String?
    var username: String?
    var imageUrl: String?
    
    init() {
    }
    
    init(email: String, username: String, imageUrl: String) {
        self.email = email
        self.username = username
        self.imageUrl = imageUrl
    }
}
