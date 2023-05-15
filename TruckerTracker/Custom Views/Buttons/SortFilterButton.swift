//
//  SortFilterButton.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/15/23.
//

import UIKit

// MARK: - SortFilterButton Type
enum SortFilterButtonType: String {
    case sort
    case filter
    
    var title: String {
        return self.rawValue.capitalized
    }
    
    var image: UIImage? {
        switch self {
        case .sort:
            return SFSymbols.arrowUpDown
        case .filter:
            return SFSymbols.linesDown
        }
    }
}

// MARK: - SortFilterButton
class SortFilterButton: UIButton {

    // Font attributes
    private let titleFontSize: CGFloat = 18
    private let titleFontWeight: UIFont.Weight = .medium
    
    private let buttonForegroundColor: UIColor = .label
    private let buttonBackgroundColor: UIColor = .systemGray6
    
    // Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: SortFilterButtonType) {
        self.init(frame: .zero)

        set(buttonType: type)
    }
    
    // Configuration
    private func configure() {
        configuration = .filled()
        dropShadow(opacity: 0.1)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func set(buttonType: SortFilterButtonType) {
        var attTitle = AttributedString(buttonType.title)
        attTitle.font = UIFont.systemFont(ofSize: titleFontSize, weight: titleFontWeight)
        configuration?.attributedTitle = attTitle
        
        configuration?.image = buttonType.image
        configuration?.imagePadding = 10
        
        configuration?.buttonSize = .small
        configuration?.cornerStyle = .large
        
        configuration?.baseBackgroundColor = buttonBackgroundColor
        configuration?.baseForegroundColor = buttonForegroundColor
    }
}

