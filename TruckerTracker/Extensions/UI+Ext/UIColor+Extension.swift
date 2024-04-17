//
//  UIColor+Extension.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/17/24.
//

import UIKit

extension UIColor {
    // MARK: Hex
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexValue.hasPrefix("#") { hexValue = String(hexValue.dropFirst()) }
        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
