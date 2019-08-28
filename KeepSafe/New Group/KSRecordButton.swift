//
//  KSRecordButton.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-08-26.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import UIKit

struct Colors {
    static let recordBlue = UIColor(red: 29.0/255.0, green: 161.0/255.0, blue: 242.0, alpha: 1.0)
}

class KSRecordButton: UIButton {
    var isOn = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    func initButton() {
        layer.borderWidth = 2.0
        layer.borderColor = Colors.recordBlue.cgColor
        layer.cornerRadius = frame.size.height / 2
        
        setTitleColor(Colors.recordBlue, for: .normal)
        addTarget(self, action: #selector(KSRecordButton.buttonPressed), for: .touchUpInside)
        
    }
    @objc func buttonPressed() {
        activateButton(bool: !isOn)
    }
    func activateButton(bool: Bool) {
        
        isOn = bool
        let color = bool ? Colors.recordBlue : .clear
        let title = bool ? "Recording" : "Record"
        let titleColor = bool ? .white : Colors.recordBlue
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = color
    }

}
