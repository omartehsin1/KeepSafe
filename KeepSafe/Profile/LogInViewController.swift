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
        navigationController?.navigationBar.isHidden = false
        createToolBar()

    }
    func createToolBar() {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        //let doneBtn: UIBarButtonItem = UIBarButtonItem(title: “Done”, style: .done, target: self, action: Selector(“doneButtonAction”))
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        
        
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
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
                    case .userNotFound:
                        Alert.showIncorrectEmailAlert(on: self)
                    case .wrongPassword:
                        Alert.showInvalidPasswordAlert(on: self)
                    case .missingEmail:
                        Alert.showIncompleteFormAlert(on: self)
                    default:
                        Alert.showUnableToRetrieveDataAlert(on: self)
                        
                    }
                    
                }
                spinnerView.removeSpinner()
                return
            } else {
                //self.performSegue(withIdentifier: "goToMainFromLogIn", sender: self)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "HomePage")
                self.present(controller, animated: true, completion: nil)
                spinnerView.removeSpinner()
            }
        }
        
    }

}



