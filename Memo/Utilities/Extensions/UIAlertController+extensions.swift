//
//  UIAlert+extensions.swift
//  Memo
//
//  Created by klioop on 2021/11/10.
//

import UIKit

extension UIAlertController {
    
    func addActions(_ actions: UIAlertAction...) {
        actions.forEach { self.addAction($0) }
    }
}
