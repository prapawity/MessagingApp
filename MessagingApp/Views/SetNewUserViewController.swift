//
//  SetNewUserViewController.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 16/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit
import PopupDialog
class SetNewUserViewController: UIViewController {
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextfield: UITextField!
    var imagePicker = UIImagePickerController()
    var userEmail: String?
    let viewModel = SetNewUserViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        self.title = "Setup Detail"
        imagePicker.delegate = self
        navigationItem.hidesBackButton = true
        
    }

    @IBAction func setImageButtonAction(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        
        blockAction(state: true)
        var title: String!
        var message: String!
        var button: DefaultButton!
        guard usernameTextfield.text?.isEmpty == false else {
            title = "Failed"
            message = "Please Fill Your Username"
            button = DefaultButton(title: "OK", dismissOnTap: true){
                self.blockAction(state: false)
            }
            return showDialog(title: title, message: message, button: button)
        }
        activityIndicator.isHidden = false
        viewModel.saveDatatoFirebase(email: userEmail!, username: usernameTextfield.text!, image: imageButton.imageView?.image) { (result, reason) in
            guard result == .success else {
                title = "Failed"
                message = reason
                button = DefaultButton(title: "OK", dismissOnTap: true){
                    self.blockAction(state: false)
                }
                return self.showDialog(title: title, message: message, button: button)
            }
            title = "Success"
            message = "Congratulation you've setting information succeed"
            button = DefaultButton(title: "OK", dismissOnTap: true){
                self.performSegue(withIdentifier: "toMainPage", sender: nil)
            }
            self.showDialog(title: title, message: message, button: button)
            
        }

    }
    
    private func showDialog(title: String, message: String, button: DefaultButton){
        let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, tapGestureDismissal: false, panGestureDismissal: false, hideStatusBar: true) {}
         popup.addButtons([button])
        self.present(popup, animated: true, completion: nil)
        
    }
    
    private func blockAction(state: Bool){
        activityIndicator.isHidden = !state
        usernameTextfield.isEnabled = !state
        saveButton.isEnabled = !state
        
    }
    
}

extension SetNewUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(pickedImage.description)
            imageButton.imageView?.contentMode = .scaleToFill
            imageButton.setImage(pickedImage, for: .normal)
           }
        
           dismiss(animated: true, completion: nil)
    }
}
