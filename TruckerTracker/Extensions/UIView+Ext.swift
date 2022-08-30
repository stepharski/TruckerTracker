//
//  UIView+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/29/22.
//

import UIKit

extension UIView {
    
    func applyGradient(colors: [UIColor], locations: [NSNumber]?) {
        assert(colors.count >= 2, "There must be at least 2 colors")
        
        if locations != nil {
            assert(colors.count == locations?.count, "Locations must have the same size of color array")
        }
        
        let gradient = CAGradientLayer()
        
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = self.layer.cornerRadius
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}
