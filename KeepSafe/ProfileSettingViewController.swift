//
//  ProfileSettingViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-04.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class ProfileSettingViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveBTNPressed(_ sender: Any) {
        //print(phoneNumberTextField.text)
    }
    
    


}

extension ProfileSettingViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            // Do something...
            phoneNumberTextField.getFormattedPhoneNumber(format: .E164)           // Output "+33600000001"
            phoneNumberTextField.getFormattedPhoneNumber(format: .International)  // Output "+33 6 00 00 00 01"
            phoneNumberTextField.getFormattedPhoneNumber(format: .National)       // Output "06 00 00 00 01"
            phoneNumberTextField.getFormattedPhoneNumber(format: .RFC3966)        // Output "tel:+33-6-00-00-00-01"
            phoneNumberTextField.getRawPhoneNumber()                               // Output "600000001"
        }
    }
    
    
}
