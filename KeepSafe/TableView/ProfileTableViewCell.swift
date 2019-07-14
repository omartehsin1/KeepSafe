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
    @IBOutlet weak var theUsernameLabel: UILabel!
    @IBOutlet weak var locationTitle: UILabel!
    let homePageVC = HomePageViewController()
    
    func setProfileItem(profileItems: ProfileItems) {
        profileImage.layer.cornerRadius = (profileImage.bounds.height) / 2
        profileImage.clipsToBounds = true
        

        
//        homePageVC.loadProfileImageView { (userImage) in
//            profileItems.profileImage = userImage
//            self.profileImage = profileItems.profileImage
//        }
        
        homePageVC.loadProfileImageView { (userImageURL) in
            profileItems.profileImage.loadImageUsingCache(urlString: userImageURL)
            self.profileImage.loadImageUsingCache(urlString: userImageURL)
        }
        
        locationTitle.text = profileItems.location
        
        
        homePageVC.loadUserName(completion: { username in
            profileItems.theUsername = username
            self.theUsernameLabel.text = profileItems.theUsername
        })
    }
    
    
 
}
