//
//  UITableViewCell+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 9/29/22.
//

import UIKit

extension UITableViewCell {
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
