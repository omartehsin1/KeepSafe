//
//  MenuTableViewCell.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-12.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconTitleLabel: UILabel!
    
    func setMenuItem(menuItems: MenuItems) {
        iconImageView.image = menuItems.image
        iconTitleLabel.text = menuItems.title
    }
    

}
