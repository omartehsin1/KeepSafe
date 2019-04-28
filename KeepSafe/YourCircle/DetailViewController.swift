//
//  DetailViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-18.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase
import PMSuperButton

class DetailViewController: UIViewController {
    
    var nameOfUser : String = "No Name"
    var email : String = "No Email"
    var profileImage = UIImage()
    
    var databaseRef = Database.database().reference()
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfUserLabel.text = nameOfUser
        emailLabel.text = email
        profileImageView.image = profileImage

    }
    
    @IBAction func addFriendBTNPressed(_ sender: Any) {
        addFriends()
        dismiss(animated: true, completion: nil)
    }
    func btnPressed(image: UIImage) {
        
    }
    
    func addFriends() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        databaseRef.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value)
            
            let profileImageURL = (snapshot.value as! NSDictionary)["profileImageURL"] as! String
            let url = URL(string: profileImageURL)
            let data = try? Data(contentsOf: url!)
        }
        
        
    }
    
    
}
