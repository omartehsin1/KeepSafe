//
//  DetailViewController.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-18.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var nameOfUser = String()
    var email = String()
    var profileImageURL = UIImage()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.image = profileImageURL
        nameOfUserLabel.text = nameOfUser
        emailLabel.text = email

        // Do any additional setup after loading the view.
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
