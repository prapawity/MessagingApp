//
//  FriendChatCell.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 15/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit

class FriendChatCell: UITableViewCell {
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(image: UIImage, message: String){
        imageAvatar.image = image
        messageText.text = message
        
    }
    
}
