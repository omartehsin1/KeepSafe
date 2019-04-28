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
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Incomplete Form", message: "Please fill out all the fields in the form")
    }
    static func showInvalidEmailAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Invalid Email", message: "Please use a correct email")
    }
    
    static func showInvalidPasswordAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Invalid Password", message: "Password is invalid")
    }
    
    static func showUnableToRetrieveDataAlert(on vc: UIViewController) {
        showBasicAction(on: vc, with: "Unable to Retrieve Data", message: "Network Error")
    }
}
