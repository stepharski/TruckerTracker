//
//  UICollectionViewCell+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/12/22.
//

import UIKit

extension UICollectionViewCell {
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
