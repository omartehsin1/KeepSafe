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
import FlagPhoneNumber



class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var defaultImage: UIImageView!

    let imagePicker = UIImagePickerController()
    @IBOutlet weak var emailTextField: MinoruTextField!
    @IBOutlet weak var usernameTextField: MinoruTextField!
    @IBOutlet weak var passwordTextField: MinoruTextField!
    @IBOutlet weak var firstNameTextField: MinoruTextField!
    @IBOutlet weak var lastNameTextField: MinoruTextField!
    @IBOutlet weak var phoneNumberTextField: FPNTextField!
    
    
    
    //api key: AIzaSyDwRXi5Q3L1rTflSzCWd4QsRzM0RwcGjDM
    var registeredUser = [Users]()
    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultImage.isUserInteractionEnabled = true
        navigationController?.navigationBar.isHidden = false
        createToolBar()
        
        //Delegates:
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        //Tags:
        emailTextField.tag = 0
        firstNameTextField.tag = 1
        lastNameTextField.tag = 2
        usernameTextField.tag = 3
        passwordTextField.tag = 4
        
        
        phoneNumberTextField.tag = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: .keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: .keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: .keyboardWillChangeFrameNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[Notification.Name.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
            
        }
        if notification.name == Notification.Name.keyboardWillShowNotification ||
            notification.name == Notification.Name.keyboardWillChangeFrameNotification {
            
            view.frame.origin.y = -keyboardRect.height + 100
        } else {
            view.frame.origin.y = 0
        }
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
        usernameTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        firstNameTextField.inputAccessoryView = toolbar
        lastNameTextField.inputAccessoryView = toolbar
        phoneNumberTextField.textFieldInputAccessoryView = toolbar
        //phoneNumberTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
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
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let usernameText = usernameTextField.text, let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let phoneNumber = phoneNumberTextField.text else {
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
            self.ref.child("users").child(uid).setValue(["friends": self.registeredUser])
            
            
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
                                
                                let values = ["nameOfUser": usernameText, "email": email, "profileImageURL": downloadString, "firstName": firstName, "lastName": lastName, "phoneNumber": phoneNumber, "uid": uid]
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomePage")
            self.present(controller, animated: true, completion: nil)
            //self.performSegue(withIdentifier: "goToMain", sender: self)
            
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

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
