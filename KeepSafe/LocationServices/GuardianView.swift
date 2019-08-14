//
//  GuardianView.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-08-09.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

class GuardianView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var turnOffButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed("GuardianView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
