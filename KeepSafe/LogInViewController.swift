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
        setUpRootViewController()


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
                print(error)
                return
            } else {
                self.performSegue(withIdentifier: "goToMainFromLogIn", sender: self)
                print("success")
                spinnerView.removeSpinner()
            }
        }
        
    }
    
    func setUpRootViewController() {

        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let homepageVC = HomePageViewController()
                let homepageNC = UINavigationController(rootViewController: homepageVC)
                self.present(homepageNC, animated: false, completion: nil)
                
                //self.handleLogIn()
                print("Already Logged In")
                
            } else {
                let welcomeVC = WelcomeViewController()
                let welcomeNC = UINavigationController(rootViewController: welcomeVC)
                self.present(welcomeNC, animated: false, completion: nil)
            }
        }
        
    }


}



