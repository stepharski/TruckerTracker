//
//  Array+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/29/23.
//

import Foundation

extension Array {
    
  subscript (safe index: Int) -> Element? {
    return index < count ? self[index] : nil
  }
    
}
