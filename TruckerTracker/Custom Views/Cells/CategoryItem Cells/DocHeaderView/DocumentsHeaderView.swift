//
//  DocumentsHeaderView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/24/22.
//

import UIKit

class DocumentsHeaderView: UIView {

    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubview(titleLabel)
        
        titleLabel.textColor = #colorLiteral(red: 0.9277959466, green: 0.9277958274, blue: 0.9277958274, alpha: 0.8)
        titleLabel.text = "Documents"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
