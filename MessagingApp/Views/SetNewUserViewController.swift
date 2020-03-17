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
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
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


}

extension SetNewUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageButton.imageView?.contentMode = .scaleAspectFit
            imageButton.setImage(pickedImage, for: .normal)
           }
        
           dismiss(animated: true, completion: nil)
    }
}
