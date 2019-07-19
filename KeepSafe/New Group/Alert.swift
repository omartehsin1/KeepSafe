//
//  Alert.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-28.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    private static func showBasicAction(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
        
    }
    
    static func showFollowConfirmationAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Follow Request", message: "Are you sure you want this user to follow you?")
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Incomplete Form", message: "Please fill out all the fields in the form")
    }
    static func showInvalidEmailAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Invalid Email", message: "Please use a correct email")
    }
    
    static func showInvalidPasswordAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Invalid Password", message: "Password is invalid")
    }
    
    static func showEmailAlreadyInUseAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Email Already In Use", message: "This Email Address has already been registeres")
    }
    static func showWeakPasswordAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Password too weak", message: "Please try again with a stronger password")
    }
    
    static func showUnableToRetrieveDataAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Unable to Retrieve Data", message: "Network Error")
    }
    static func showIncorrectEmailAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Email is incorrect", message: "Please try again with the right email address")
    }
    static func showUpdatedSuccessAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Success", message: "Your information has been successfully updated")
    }
}
