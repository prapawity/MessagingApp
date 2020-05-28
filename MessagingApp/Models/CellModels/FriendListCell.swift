//
//  FriendListCell.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 14/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit
import LoadingPlaceholderView
class FriendListCell: UITableViewCell {
    private let viewModel = FriendListCellViewModel()
    private let loading = LoadingPlaceholderView()
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var avaterImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loading.cover(cropView, animated: true)
    }
    
    func setCell(email: String){
        viewModel.setInformationCell(email: email) { (image, name) in
            self.avaterImage.image = image
            self.nameLabel.text = name
            self.loading.uncover(animated: true)
        }
    }
    
}
