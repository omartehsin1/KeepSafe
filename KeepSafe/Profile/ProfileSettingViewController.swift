//
//  ProfileSettingViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-07-04.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import Firebase

class ProfileSettingViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.delegate = self
        loadUserProfile()
        userImageView.isUserInteractionEnabled = true
        //let theToken
        // Do any additional setup after loading the view.
//        let sender = PushNotificationSender()
//        sender.sendPushNotification(to: result.token, title: "The message", body: "Sent from iPhone 6")
//
        
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instance ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                //self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
//
//            }
//        }
        

    }
    @objc func printToken(notification: Notification) {
        print("notification value is: \(String(describing: notification.userInfo))")
    }
    
    
    @IBAction func imageTapped(_ sender: Any) {
        changeImage()
    }
    
    
    
    @IBAction func saveBTNPressed(_ sender: Any) {
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        guard let firstName = self.firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let phoneNumber = phoneNumberTextField.text
            else {
                return
                
        }
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        
        
        
        
        
        if let uploadData = self.userImageView.image?.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storageRef.downloadURL(completion: { (url, erro) in
                    if (erro == nil) {
                        if let downloadurl = url {
                            let downloadString = downloadurl.absoluteString
                            let dictionary = ["firstName" : firstName, "lastName": lastName, "email": email, "phoneNumber": phoneNumber, "profileImageURL": downloadString]
                            FirebaseConstants.userDatabase.child(myUID).updateChildValues(dictionary) { (error, ref) in
                                if error != nil {
                                    Alert.showUnableToRetrieveDataAlert(on: self)
                                } else {
                                    Alert.showUpdatedSuccessAlert(on: self)
                                    //self.dismiss(animated: true, completion: nil)
                                }
                            }
                            
                            
                        }
                    }
                    else {
                        print(erro!)
                    }
                })
            }
        }
        
    }
    func loadUserProfile() {
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.userDatabase.child(myUID).observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.firstNameTextField.text = dictionary["firstName"] as? String ?? ""
                self.lastNameTextField.text = dictionary["lastName"] as? String ?? ""
                self.emailTextField.text = dictionary["email"] as? String ?? ""
                self.phoneNumberTextField.text = dictionary["phoneNumber"] as? String ?? ""
                let imageURL = dictionary["profileImageURL"] as? String ?? ""
                
                DispatchQueue.main.async {
                    self.userImageView.loadImageUsingCache(urlString: imageURL)
                }
            }
        }
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

extension ProfileSettingViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            userImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    func changeImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
}
