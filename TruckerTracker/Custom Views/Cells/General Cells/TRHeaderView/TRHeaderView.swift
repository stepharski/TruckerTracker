//
//  TRHeaderView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/30/22.
//

import UIKit

//MARK: - HeaderTitleColorType
enum HeaderTitleColorType {
    case lightWhite, fadedWhite
    
    var color: UIColor {
        switch self {
        case .lightWhite:
            return #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        case .fadedWhite:
            return #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 0.8)
        }
    }
}

//MARK: - TRHeaderView
class TRHeaderView: UITableViewHeaderFooterView {

    static var identifier: String {
        return String(describing: self)
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleColor: HeaderTitleColorType = .lightWhite {
        didSet {
            titleLabel.textColor = titleColor.color
        }
    }
    
    var labelCenterYPadding: CGFloat = 5
    
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let padding: CGFloat = 5
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYPadding)
        ])
        
        return label
    }()
}
