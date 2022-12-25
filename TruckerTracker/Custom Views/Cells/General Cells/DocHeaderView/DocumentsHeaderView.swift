//
//  DocumentsHeaderView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/24/22.
//

import UIKit

class DocumentsHeaderView: UITableViewHeaderFooterView {

    static var identifier: String {
        return String(describing: self)
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9277959466, green: 0.9277958274, blue: 0.9277958274, alpha: 0.8)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        let padding: CGFloat = 5
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: padding),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
        ])
        
        return label
    }()
}
