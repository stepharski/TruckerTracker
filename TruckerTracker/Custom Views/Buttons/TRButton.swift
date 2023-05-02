//
//  TRButton.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/10/22.
//

import UIKit

//MARK: - Button Type
// Size
enum TRButtonSizeType {
    case capsule, rectangle
    
    var cornerStyle: UIButton.Configuration.CornerStyle {
        switch self {
        case .capsule:  return .capsule
        case .rectangle: return .small
        }
    }
}

// Color
enum TRButtonColorType {
    case dark, red
    
    var foregroundColor: UIColor {
        return .systemBackground
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .dark: return .label
        case .red:  return .systemRed
        }
    }
    
    var shadowColor: UIColor {
        switch self {
        case .dark: return .label.withAlphaComponent(0.5)
        case .red:  return .label.withAlphaComponent(0.25)
        }
    }
}

//MARK: -  TRButton
class TRButton: UIButton {

    // Font attributes
    private let titleFontSize: CGFloat = 16
    private let titleFontWeight: UIFont.Weight = .semibold
    
    // Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, color: TRButtonColorType, size: TRButtonSizeType) {
        self.init(frame: .zero)

        set(title: title, color: color, size: size)
    }
    
    // Configuration
    private func configure() {
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(title: String, color: TRButtonColorType, size: TRButtonSizeType) {
        var attTitle = AttributedString(title)
        attTitle.font = UIFont.systemFont(ofSize: titleFontSize, weight: titleFontWeight)
        
        configuration?.attributedTitle = attTitle
        configuration?.cornerStyle = size.cornerStyle
        configuration?.baseBackgroundColor = color.backgroundColor
        configuration?.baseForegroundColor = color.foregroundColor
        
        dropShadow(color: color.shadowColor)
    }
}
