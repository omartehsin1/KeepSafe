//
//  ProfileTableViewCell.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-13.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var locationTitle: UILabel!
    let homePageVC = HomePageViewController()
    
    func setProfileItem(profileItems: ProfileItems) {
        
        profileImage.image = profileItems.profileImage
        
        locationTitle.text = profileItems.location
        homePageVC.loadUserName(completion: { username in
            profileItems.nameTitle = username
            self.nameTitle.text = profileItems.nameTitle
        })
    }
    
    
 
}
