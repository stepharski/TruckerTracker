//
//  UISearchBar+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/6/22.
//

import UIKit

extension UISearchBar {
    
    // Search Icon
    func setMagnifyingGlassColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
    
    // Clear Button
    func setClearButtonColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as? UIButton
        clearButton?.setImage(clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton?.tintColor = color
    }
    
    // Placeholder
    func setPlaceholderTextColorTo(color: UIColor) {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
}
