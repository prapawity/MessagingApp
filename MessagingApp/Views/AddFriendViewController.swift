//
//  AddFriendViewController.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 10/4/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit
import PopupDialog
class AddFriendViewController: UIViewController {
    
    private var emailTf:String!
    private let viewModel = AddFriendViewModel()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var avatarResult: UIImageView!
    @IBOutlet weak var resultNameLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var showResultStack: UIView!
    @IBOutlet weak var searchTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        navigationBar.topItem?.title = "Finding Friend"
    }

    @IBAction func findingFriend(_ sender: Any) {
        showResultStack.isHidden = true
        guard searchTF.text?.isEmpty == false else {
            return setAlertBox(title: "Failed", message: "Please Input Email to find your friend")
        }
        emailTf = searchTF.text!
        activityIndicator.isHidden = false
        viewModel.findingFriendFromViewModel(email: emailTf) { (resultType, userDetail, image) in

            self.activityIndicator.isHidden = true
            if resultType == .success {
                self.viewModel.isFriend(friendEmail: self.emailTf) { (resultType) in
                    if resultType == .success {
                        self.addFriendBtn.isEnabled = false
                        self.addFriendBtn.backgroundColor = .gray
                    } else{
                        self.addFriendBtn.isEnabled = true
                        self.addFriendBtn.backgroundColor = .green
                    }
                    self.showResultStack.isHidden = false
                    self.resultNameLabel.text = userDetail.email!
                    self.avatarResult.image = image
                }
                
            } else{
                self.setAlertBox(title: "Failed", message: "No Friend Found")
            }
        }
    }
    @IBAction func addFriendAction(_ sender: Any) {
        viewModel.addFriendFromViewModel(friendEmail: emailTf) { (resultType) in
            if resultType == .success {
                self.addFriendBtn.isEnabled = false
                self.addFriendBtn.backgroundColor = .gray
                self.setAlertBox(title: "Success", message: "Friend was added")
            } else{
                self.setAlertBox(title: "Failed", message: "Something wrong")
            }
        }
    }
    
    private func setAlertBox(title: String,message: String){
        let button =  DefaultButton(title: "OK", dismissOnTap: true){}
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, tapGestureDismissal: false, panGestureDismissal: false, hideStatusBar: true) {}
         popup.addButtons([button])
        self.present(popup, animated: true, completion: nil)
    }

}
// ทำ Add Friend + check ว่าเป็นตัวเองหรือป่าว หรือเป็นเพื่อนร่วมกันหรือยัง
