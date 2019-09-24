//
//  AppSettings.swift
//  KeepSafe
//
//  Created by Omar Tehsin on 2019-08-29.
//  Copyright © 2019 Omar Tehsin. All rights reserved.
//

import Foundation

final class AppSettings {
    private enum SettingKey: String {
        case displayName
    }
    static var displayName: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingKey.displayName.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.displayName.rawValue
            
            if let name = newValue {
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
        
    }
}
