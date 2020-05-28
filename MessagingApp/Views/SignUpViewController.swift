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

    @IBOutlet weak var activityIncicator: UIActivityIndicatorView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var textfieldStack: UIStackView!
    
    
    private let viewModel = SignUpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupUserAction(_ sender: Any) {
        loading(state: true)
        
        viewModel.signupNewUserWithEmailandPassword(email: emailTextfield.text ?? "", password: passwordTextfield.text ?? "", conPassword: confirmPasswordTextfield.text ?? "") { (registerResultCompletion, reason) in
            var title: String!
            var message: String!
            var button: DefaultButton!
            
            if registerResultCompletion == .success {
                title = "Register Successfully"
                message = "Please Click OK to continue"
                button = DefaultButton(title: "OK", dismissOnTap: true){
                    self.loading(state: false)
                    self.performSegue(withIdentifier: "newUser", sender: self.emailTextfield.text!)
                }
            } else{
                title = "Register Failure"
                message = reason
                button = DefaultButton(title: "OK", dismissOnTap: true){
                    self.loading(state: false)
                }
            }
            let popup = PopupDialog(title: title, message: message, buttonAlignment: .horizontal, transitionStyle: .zoomIn, tapGestureDismissal: false, panGestureDismissal: false, hideStatusBar: true) {}
             popup.addButtons([button])
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newUser"{
            if let destination = segue.destination as? SetNewUserViewController{
                destination.userEmail = sender as? String
            }
        }
    }
    
    private func loading(state: Bool){
        activityIncicator.isHidden = !state
        textfieldStack.isHidden = state
        registerButton.isHidden = state
    }
    
}
