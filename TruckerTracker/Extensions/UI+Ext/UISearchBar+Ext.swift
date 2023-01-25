//
//  UISearchBar+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/6/22.
//

import UIKit

extension UISearchBar {
    
    func setMagnifyingGlassColorTo(color: UIColor) {
        // Search Icon
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }

    func setClearButtonColorTo(color: UIColor) {
        // Clear Button
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as? UIButton
        clearButton?.setImage(clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton?.tintColor = color
    }

    func setPlaceholderTextColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
}
