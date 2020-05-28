//
//  FriendListCellViewModel.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 11/4/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import Foundation
import UIKit
class FriendListCellViewModel {
    
    private let imageManager = ImageManager()
    private let userManager = UserDetailManager()
    
    func setInformationCell(email: String, completion: @escaping (UIImage, String) -> Void) {
        userManager.getUserInformation(email: email) { (result, userDetail) in
            if result == .success {
                if userDetail.imageUrl != "" {
                    self.imageManager.downloadImage(path: userDetail.imageUrl!) { (resultType, image) in
                        completion(image,userDetail.email!)
                    }
                } else {
                    completion(#imageLiteral(resourceName: "logo"), userDetail.email!)
                }
            } else {
                completion(#imageLiteral(resourceName: "logo"), "Failed")
            }
        }
    }
}
