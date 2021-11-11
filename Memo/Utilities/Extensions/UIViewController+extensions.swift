//
//  UIViewController+extensions.swift
//  Memo
//
//  Created by klioop on 2021/11/10.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, okTitle: String, okAction: @escaping () -> ()) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            okAction()
        }
        
        alert.addActions(cancel, ok)
        self.present(alert, animated: true)
    }
    
    func showDestructiveAlert(
        title: String,
        message: String?,
        destructionTitle: String = "Delete",
        destructiveAction: @escaping () -> Void
    ) -> Void {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let destruction = UIAlertAction(title: destructionTitle, style: .destructive) { _ in
            destructiveAction()
        }
        
        alert.addActions(cancel, destruction)
        self.present(alert, animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
   
}

