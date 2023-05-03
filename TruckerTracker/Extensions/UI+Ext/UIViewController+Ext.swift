//
//  UIViewController+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/26/22.
//

import UIKit

extension UIViewController {
    
    // Visibility
    var isViewVisible: Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    // Keyboard
    func dismissKeyboardOnTouchOutside() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Alert
    func showAlert(title: String, message: String) {
        let alertVC = AlertViewController(title: title, message: message)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: false)
    }
}

