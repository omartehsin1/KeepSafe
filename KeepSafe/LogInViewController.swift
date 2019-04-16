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

var vSpinner: UIView?

class LogInViewController: UIViewController {
    @IBOutlet weak var emailTextField: MinoruTextField!
    @IBOutlet weak var passwordTextField: MinoruTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //handleLogIn()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        handleLogIn()
        showSpinner(onView: self.view)
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
                self.removeSpinner()
            }
        }
        
    }


}


extension LogInViewController {
    func showSpinner(onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
