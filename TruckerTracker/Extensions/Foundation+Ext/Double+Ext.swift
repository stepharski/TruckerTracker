//
//  Double+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/28/23.
//

import Foundation

extension Double {
    
    var formattedString: String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", self)
        } else {
            return String(describing: self)
        }
    }
    
}
