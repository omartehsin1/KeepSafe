//
//  RegisterViewController.swift
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



class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var defaultImage: UIImageView!
    @IBOutlet weak var profilePicBTN: UIButton!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var emailTextField: MinoruTextField!
    @IBOutlet weak var usernameTextField: MinoruTextField!
    @IBOutlet weak var passwordTextField: MinoruTextField!
    //api key: AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM

    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultImage.isUserInteractionEnabled = true
        
        

    }
    
    
    // MARK: Image Picker
    
    @IBAction func imageTapped(_ sender: Any) {
        changeImage()
        
    }
    
    
    func changeImage() {
        let alertController = UIAlertController(title: "Change Photo", message: "To change your photo, you can:", preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (alertAction) in
            if UIImagePickerController.isCameraDeviceAvailable(.front) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let pickPhotoAction = UIAlertAction(title: "Pick Photo", style: .default) { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(takePhotoAction)
        alertController.addAction(pickPhotoAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage
        {
            defaultImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Registration
    
    @IBAction func restrationBTNPressed(_ sender: PMSuperButton) {
        spinnerView.showSpinner(onView: self.view)
        guard let email = emailTextField.text, let password = passwordTextField.text, let usernameText = usernameTextField.text else {
            print("Form is not valied")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
                return
            }
            guard let uid = user?.user.uid else { return }
            spinnerView.removeSpinner()
            self.performSegue(withIdentifier: "goToMain", sender: self)
            
            
            let ref = Database.database().reference(fromURL: "https://keep-safe-1e8eb.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["nameOfUser": usernameText, "email": email]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                
                print("Saved user successfully into firebase db")
            })
        }

    }

}


