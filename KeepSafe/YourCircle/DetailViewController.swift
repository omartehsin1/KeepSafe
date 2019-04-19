//
//  DetailViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-18.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    var nameOfUser : String = "No Name"
    var email : String = "No Email"
    var profileImage = UIImage()
    
    var ref: DatabaseReference?
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfUserLabel.text = nameOfUser
        emailLabel.text = email
        profileImageView.image = profileImage

    }

}
