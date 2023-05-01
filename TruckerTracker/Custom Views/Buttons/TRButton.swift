//
//  TRButton.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/10/22.
//

import UIKit

// Button type
enum TRButtonType {
    case dark, red
    
    var backgroundColor: UIColor {
        switch self {
        case .dark:
            return .label
        case .red:
            return .systemRed
        }
    }
    
    var foregroundColor: UIColor {
        return #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
    }
    
    var shadowColor: UIColor {
        switch self {
        case .dark:
            return .label.withAlphaComponent(0.5)
        case .red:
            return .label.withAlphaComponent(0.25)
        }
    }
}

// TRButton
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
    
    convenience init(title: String, type: TRButtonType) {
        self.init(frame: .zero)

        set(title: title, type: type)
    }
    
    // Configuration
    private func configure() {
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(title: String, type: TRButtonType) {
        var attTitle = AttributedString(title)
        attTitle.font = UIFont.systemFont(ofSize: titleFontSize, weight: titleFontWeight)
        
        configuration?.attributedTitle = attTitle
        configuration?.baseBackgroundColor = type.backgroundColor
        configuration?.baseForegroundColor = type.foregroundColor
        
        dropShadow(color: type.shadowColor)
    }
}
