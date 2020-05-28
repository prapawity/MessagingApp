//
//  ChatListCell.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 14/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var avaterImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func settUICell(image: UIImage, name: String, messageText: String){
        avaterImage.image = image
        friendName.text = name
        message.text = messageText
    }
    
}
