//
//  UserDefaultWrapper.swift
//  Memo
//
//  Created by klioop on 2021/11/08.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<Value> {
    let key: String
    let defaultValue: Value
    let container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get { container.object(forKey: key) as? Value ?? defaultValue }
        set {
            container.set(newValue, forKey: key)
        }
    }
}
