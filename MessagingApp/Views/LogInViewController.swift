//
//  LogInViewController.swift
//  MessagingApp
//
//  Created by Prapawit Patthasirivichot on 14/3/2563 BE.
//  Copyright © 2563 Prapawit Patthasirivichot. All rights reserved.
//

import UIKit
import PopupDialog
class LogInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    private func setupUI(){
        activityIndicator.startAnimating()
        
        // use This
        if viewModel.checkStateLogin() {
//            UserInformationSingleton.getInstance().setUserInformation { (data) in
//                self.performSegue(withIdentifier: "loginSuccess", sender: nil)
//                self.activityIndicator.isHidden = true
//            }
        }
        loadingView.isHidden = true
        loginView.isHidden = false
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        loadingView.isHidden = false
        loginView.isHidden = true
        viewModel.loginWithEmailandPassword(email: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (result, reason) in
            if result == .failed {
                self.loadingView.isHidden = true
                self.loginView.isHidden = false
                let popup = PopupDialog(title: "Failed", message: reason, buttonAlignment: .horizontal, transitionStyle: .zoomIn, tapGestureDismissal: true, panGestureDismissal: true, hideStatusBar: true) {
                }
                let button = DefaultButton(title: "OK", dismissOnTap: true){}
                popup.addButtons([button])
                self.present(popup, animated: true, completion: nil)
            } else{
                UserInformationSingleton.getInstance().setUserInformation { (data) in
                    print("check : " ,data)
                    self.performSegue(withIdentifier: "loginSuccess", sender: nil)
                }
            }

        }
    }
    
}
