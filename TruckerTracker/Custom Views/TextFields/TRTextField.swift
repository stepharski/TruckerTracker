//
//  TRTextField.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/26/22.
//

import UIKit

class TRTextField: UITextField {

    var textPadding = UIEdgeInsets(top: 8, left: 5,
                                   bottom: 8, right: 5)
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
