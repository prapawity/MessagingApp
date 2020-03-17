//
//  SignUpViewController.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 14/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit
import PopupDialog
class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    private let viewModel = SignUpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupUserAction(_ sender: Any) {
        viewModel.signupNewUserWithEmailandPassword(email: emailTextfield.text ?? "", password: passwordTextfield.text ?? "", conPassword: confirmPasswordTextfield.text ?? "") { (RegisterResultCompletion, reason) in
            var title: String!
            var message: String!
            var button: DefaultButton!
            if RegisterResultCompletion == .success {
                title = "Register Successfully"
                message = "Back to Login page and Login again"
                button = DefaultButton(title: "OK", dismissOnTap: true){
                    self.performSegue(withIdentifier: "newUser", sender: nil)
                }
            } else{
                title = "Register Failure"
                message = reason
                button = DefaultButton(title: "OK", dismissOnTap: true){}
            }
            let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: true) {}
             popup.addButtons([button])
            self.present(popup, animated: true, completion: nil)
        }
    }
    
}
