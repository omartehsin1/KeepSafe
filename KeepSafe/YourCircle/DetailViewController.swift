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
    
    var nameOfUser = String()
    var email = String()
    var profileImageURL = UIImage()
    
    var ref: DatabaseReference?
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameOfUserLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileData()
    

        // Do any additional setup after loading the view.
    }
    
    func loadProfileData() {
        if let ref = ref {
            ref.observe(.value) { (user) in
                let user = Users()
                self.nameOfUserLabel.text = user.nameOfUser
                self.emailLabel.text = user.email
                //self.profileImageView.image = UIImage(URLwi)
            }
        }
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
