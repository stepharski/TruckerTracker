//
//  TRButton.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/10/22.
//

import UIKit

enum TRButtonType {
    case light, dark, red
    
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        case .dark:
            return #colorLiteral(red: 0.1215686275, green: 0.1176470588, blue: 0.137254902, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.537254902, green: 0.09411764706, blue: 0.05882352941, alpha: 1)
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .light:
            return #colorLiteral(red: 0.1137254902, green: 0.1098039216, blue: 0.1294117647, alpha: 1)
        case .dark, .red:
            return #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        }
    }
}

class TRButton: UIButton {
    
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
    
    
    private func configure() {
        configuration = .filled()
        configuration?.cornerStyle = .capsule
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(title: String, type: TRButtonType) {
        var attTitle = AttributedString(title)
        attTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        configuration?.attributedTitle = attTitle
        configuration?.baseBackgroundColor = type.backgroundColor
        configuration?.baseForegroundColor = type.foregroundColor
    }
}
