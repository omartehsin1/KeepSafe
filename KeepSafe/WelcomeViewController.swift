//
//  WelcomeViewController.swift
//  
//
//  Created by Omar Tehsin on 2019-02-26.
//

import UIKit
import PMSuperButton
import Firebase


class WelcomeViewController: UIViewController {
    @IBOutlet weak var registerButton: PMSuperButton!
    @IBOutlet weak var logInButton: PMSuperButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "goToHome", sender: self)
            print("Logged In")
        } else {
            print("Not Logged In")
        }

    }
    



}
