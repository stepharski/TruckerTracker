//
//  ExpandFooterView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/24/22.
//

import UIKit

class ExpandFooterView: UITableViewHeaderFooterView {
    
    private let expandButton = UIButton()
    private let underlineView = UIView()

    static var identifier: String {
        return String(describing: self)
    }
    
    var isExpanded: Bool = false {
        didSet {
            expandButton.setImage(isExpanded ? SFSymbols.arrowCompactUp
                                          : SFSymbols.arrowCompactDown, for: .normal)
        }
    }
    
    var didTapExpandButton: (() -> ())?
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureExpandButton()
        configureUnderlineView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Expand button
    func configureExpandButton() {
        addSubview(expandButton)
        expandButton.imageView?.tintColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandButton.topAnchor.constraint(equalTo: self.topAnchor),
            expandButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            expandButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            expandButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
    }
    
    @objc func expandButtonTapped() {
        isExpanded = !isExpanded
        didTapExpandButton?()
    }
    
    // Underline view
    func configureUnderlineView() {
        addSubview(underlineView)
        underlineView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 0.8)
        
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underlineView.heightAnchor.constraint(equalToConstant: 1),
            underlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            underlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            underlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
}
