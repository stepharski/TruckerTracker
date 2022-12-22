//
//  TRSlider.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/21/22.
//

import UIKit

class TRSlider: UISlider {

    @IBInspectable var trackHeight: CGFloat = 2
    
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin,
                      size: CGSize(width: bounds.width, height: trackHeight))
    }
}
