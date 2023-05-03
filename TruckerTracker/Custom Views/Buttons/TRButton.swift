//
//  TRButton.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/10/22.
//

import UIKit

//MARK: - Button Type
// Action
enum TRButtonActionType {
    case confirm, destruct, cancel
    
    var foregroundColor: UIColor {
        switch self {
        case .cancel:             return .label
        case .confirm, .destruct:  return .systemBackground
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .confirm:  return .label
        case .destruct: return .systemRed
        case .cancel:   return .systemGray5
        }
    }
}
// Shape
enum TRButtonShapeType {
    case capsule, rectangle
    
    var cornerStyle: UIButton.Configuration.CornerStyle {
        switch self {
        case .capsule:   return .capsule
        case .rectangle:  return .large
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
    
    convenience init(title: String, action: TRButtonActionType, shape: TRButtonShapeType) {
        self.init(frame: .zero)

        set(title: title, action: action, shape: shape)
    }
    
    // Configuration
    private func configure() {
        configuration = .filled()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(title: String, action: TRButtonActionType, shape: TRButtonShapeType) {
        var attTitle = AttributedString(title)
        attTitle.font = UIFont.systemFont(ofSize: titleFontSize, weight: titleFontWeight)
        
        configuration?.attributedTitle = attTitle
        configuration?.cornerStyle = shape.cornerStyle
        configuration?.baseBackgroundColor = action.backgroundColor
        configuration?.baseForegroundColor = action.foregroundColor
    }
}
