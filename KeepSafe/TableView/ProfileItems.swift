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
    var profileImage: UIImageView
    var theUsername: String
    var location: String
    var email: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    
    init(profileImage: UIImageView, theUsername: String, location: String, email: String, firstName: String, lastName: String, phoneNumber: String) {
        self.profileImage = profileImage
        self.theUsername = theUsername
        self.location = location
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
}
