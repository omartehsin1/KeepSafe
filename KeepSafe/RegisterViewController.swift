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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func changeProfilePicBTN(_ sender: UIButton) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func restrationBTNPressed(_ sender: PMSuperButton) {
        
        if let email = emailTextField.text, let pass = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                if let u = user {
                    self.performSegue(withIdentifier: "goToMain", sender: self)
                }
                else {
                    print(error)
                }
            }
        }

    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage
        {
            defaultImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
