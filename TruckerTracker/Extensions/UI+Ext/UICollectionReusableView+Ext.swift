//
//  UICollectionReusableView+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/14/22.
//

import UIKit

extension UICollectionReusableView {
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
