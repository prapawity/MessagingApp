//
//  MyChatCell.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 15/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit

class MyChatCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var messageText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(image: UIImage, message: String){
        avatarImage.image = image
        messageText.text = message
        
    }
    
}
