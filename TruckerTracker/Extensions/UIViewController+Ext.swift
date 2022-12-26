//
//  UIViewController+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/26/22.
//

import UIKit

extension UIViewController {
    
    func dismissKeyboardOnTouchOutside() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

