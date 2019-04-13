//
//  ProfileItems.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-13.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Foundation
import UIKit

class ProfileItems {
    var profileImage: UIImage
    var nameTitle: String
    var location: String
    
    init(profileImage: UIImage, nameTitle: String, location: String) {
        self.profileImage = profileImage
        self.nameTitle = nameTitle
        self.location = location
    }
}
