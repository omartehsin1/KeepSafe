//
//  LogInViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-02-26.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import TextFieldEffects
import PMSuperButton

var spinnerView = SpinnerViewController()

//var vSpinner: UIView?

class LogInViewController: UIViewController {
    @IBOutlet weak var emailTextField: MinoruTextField!
    @IBOutlet weak var passwordTextField: MinoruTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    enum LogInError: Error {
        case incompleteForm
        case invalidEmail
        case incorrectPassword
    }
    
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        handleLogIn()
        spinnerView.showSpinner(onView: self.view)
        
    }
    
    
    func handleLogIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
//                print(error)
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail:
                        //todo: this is not working for some reason
                        Alert.showInvalidEmailAlert(on: self)
                        print("Email not valid")
                    
                    case .wrongPassword:
                        Alert.showInvalidPasswordAlert(on: self)
                    default:
                        Alert.showUnableToRetrieveDataAlert(on: self)
                        
                    }
                    
                }
                spinnerView.removeSpinner()
                return
            } else {
                self.performSegue(withIdentifier: "goToMainFromLogIn", sender: self)
                print("success")
                spinnerView.removeSpinner()
            }
        }
        
    }

}



