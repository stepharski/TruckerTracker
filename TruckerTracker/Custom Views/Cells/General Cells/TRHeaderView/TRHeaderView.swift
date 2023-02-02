//
//  TRHeaderView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/30/22.
//

import UIKit

//MARK: - HeaderTitleTypes
enum HeaderTitleColorType {
    case lightWhite, fadedWhite, dark
    
    var color: UIColor {
        switch self {
        case .lightWhite:
            return #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        case .fadedWhite:
            return #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 0.8)
        case .dark:
            return .label
        }
    }
}

enum HeaderTitleFontSizeType {
    case regular, large
    
    var size: CGFloat {
        switch self {
        case .regular:
            return 16
        case .large:
            return 17
        }
    }
}

//MARK: - TRHeaderView
class TRHeaderView: UITableViewHeaderFooterView {

    static var identifier: String {
        return String(describing: self)
    }
    
    private var titleLabel = UILabel()
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleColor: HeaderTitleColorType! {
        didSet {
            titleLabel.textColor = titleColor.color
        }
    }
    
    var titleSize: HeaderTitleFontSizeType! {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: titleSize.size, weight: .medium)
        }
    }
    
    var labelCenterYPadding: CGFloat = 5 {
        didSet {
            updateUI()
        }
    }
    
//    lazy var titleLabel
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureTitleLabel()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureTitleLabel() {
        titleSize = .regular
        titleColor = .lightWhite
        titleLabel.textAlignment = .left
    }
    
    func updateUI() {
        titleLabel.removeFromSuperview()
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 5
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYPadding)
        ])
    }
}