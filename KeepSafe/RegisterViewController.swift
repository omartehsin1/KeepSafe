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

    let imagePicker = UIImagePickerController()
    @IBOutlet weak var emailTextField: MinoruTextField!
    @IBOutlet weak var usernameTextField: MinoruTextField!
    @IBOutlet weak var passwordTextField: MinoruTextField!
    //api key: AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM
    var friends = [Users]()
    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultImage.isUserInteractionEnabled = true
        
        
        

    }
    
    
    // MARK: Image Picker
    
    @IBAction func imageTapped(_ sender: Any) {
        changeImage()
        
    }
    
    
    func changeImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker : UIImage?
        if let editedImage = info[.editedImage] as? UIImage
        {
            //defaultImage.image = editedImage
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            //defaultImage.image = originalImage
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            defaultImage.image = selectedImage
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
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .emailAlreadyInUse:
                        Alert.showEmailAlreadyInUseAlert(on: self)
                    case .weakPassword:
                        Alert.showWeakPasswordAlert(on: self)
                    case .invalidEmail:
                        Alert.showInvalidEmailAlert(on: self)
                    case .missingEmail:
                        Alert.showIncompleteFormAlert(on: self)
                    default:
                        Alert.showUnableToRetrieveDataAlert(on: self)
                    }
                }
                spinnerView.removeSpinner()
                return
            }
            guard let uid = user?.user.uid else { return }
            self.ref = Database.database().reference()
            self.ref.child("users").child(uid).setValue(["friends": self.friends])
            
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName).png")

            if let uploadData = self.defaultImage.image?.pngData() {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                        
                    }
                    
                    storageRef.downloadURL(completion: { (url, erro) in
                        if (erro == nil) {
                            if let downloadURL = url {
                                let downloadString = downloadURL.absoluteString
                                
                                let values = ["nameOfUser": usernameText, "email": email, "profileImageURL": downloadString, "uid": uid]
                                self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                                
                            }
                        }
                        else {
                            print(erro!)
                        }
                    })

                    

                })
                
            }
 
            spinnerView.removeSpinner()
            self.performSegue(withIdentifier: "goToMain", sender: self)
            
        }

    }
    private func registerUserIntoDatabaseWithUID(uid: String, values : [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://keep-safe-1e8eb.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err)
                return
            }
            
            print("Saved user successfully into firebase db")
        })
    }

}


