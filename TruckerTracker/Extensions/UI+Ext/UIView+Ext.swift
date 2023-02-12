//
//  UIView+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/29/22.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func pinToEdges(of superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }
    
    func roundEdges(by radius: CGFloat = 30) {
        layer.cornerRadius = radius
    }
    
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
    
    func dropShadow(color: UIColor = .black, opacity: Float = 0.5,
                    size: CGSize = CGSize(width: 3.0, height: 4.0)) {
        layer.shadowRadius = 5.0
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        layer.shadowOffset = size
        layer.shadowColor = color.cgColor
    }
}
