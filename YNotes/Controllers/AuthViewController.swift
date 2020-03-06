//
//  AuthViewController.swift
//  YNotes
//
//  Created by Dzhek on 12/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    let loadingViewController = LoadingViewController()
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    
    let mainQueue = OperationQueue.main
    let commonQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        super.viewDidDisappear(true)
        self.loginTextField.text = ""
        self.passwordTextField.text = ""
        self.loadingViewController.remove()
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.singInButton.setStyle()
        self.singInButton.setTitle("Sing in", for: .normal)
        self.singInButton.addTarget(self, action: #selector(didTapSingInButton), for: .touchUpInside)
        
        self.loginTextField.configure()
        self.loginTextField.placeholder = "Username or email"
        
        self.passwordTextField.configure()
        self.passwordTextField.placeholder = "Password"
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func didTapSingInButton() {
        guard let username = self.loginTextField.text, !self.loginTextField.text!.isEmpty
            else { print("Error 'userName' not entered"); return }

        guard let password = self.passwordTextField.text, !self.passwordTextField.text!.isEmpty
            else { print("Error 'password' not entered"); return }
        
        add(self.loadingViewController)

        (Services.login, Services.password) = (username, password)
        
        let authOperation = AuthOperation(login: Services.login, password: Services.password)
        authOperation.completionBlock = {
            if authOperation.result! {
                self.mainQueue.addOperation{
                    self.loadingViewController.remove()
                    self.performSegue(withIdentifier: "isAuth", sender: Any?.self)
                }
            }
        }
        commonQueue.addOperation(authOperation)
        
    }

}

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.returnKeyType {
        case .next:
            if let nextResponder = self.passwordTextField { nextResponder.becomeFirstResponder() }
        case .send:
            self.didTapSingInButton()
            self.dismissKeyboard()
        default:
            self.dismissKeyboard()
        }
        
        return true
    }
}
    
extension UIViewController {
        
        func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    }

struct SessionData: Decodable {
    var id: Int  = 0
    var token: String = ""
}
