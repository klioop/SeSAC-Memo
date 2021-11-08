//
//  UserDefault+extensions.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import Foundation

extension UserDefaults {
    enum Key: String {
        case hasOnBoarded
    }
    
    @UserDefaultWrapper(key: Key.hasOnBoarded.rawValue, defaultValue: false)
    static var hasOnBoarded: Bool
}
