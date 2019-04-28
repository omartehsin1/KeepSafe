//
//  String+Extension.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-04-28.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Foundation
extension String {
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
}
