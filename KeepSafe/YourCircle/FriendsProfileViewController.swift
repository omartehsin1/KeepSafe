//
//  FriendsProfileViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-05-16.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

class FriendsProfileViewController: UIViewController {
    var nameOfUser : String = "No Name"
    var email : String = "No Email"
    var profileImage = UIImage()
    var friendsUID : String = ""
    var friendProfileImageURL: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        print("The name of user \(nameOfUser)")
        //print("The email is \(email)")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "messageFriend", sender: self)
    }
    
    @IBAction func otherChatBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToOtherChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messageFriend" {
            let messageVC = segue.destination as! MessageViewController
            messageVC.recepient = nameOfUser
        }
    }
    

}
