//
//  FriendsProfileViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-05-16.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

class FriendsProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "messageFriend", sender: self)
    }
    

}
