//
//  AddActionFooterView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/27/23.
//

import UIKit

class AddActionFooterView: UITableViewHeaderFooterView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let addButton = UIButton()
    var buttonImage: UIImage? = SFSymbols.plusRectangleFill
    
    var didTapAddButton: (() -> Void)?
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        layoutUI()
        addButtonAction()
        configureAddButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAddButton() {
        var config = UIButton.Configuration.plain()
        config.image = buttonImage
        config.baseForegroundColor = .label
        addButton.configuration = config
    }
    
    private func layoutUI() {
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 45),
            addButton.heightAnchor.constraint(equalToConstant: 45),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func addButtonAction() {
        addButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc private func buttonAction() {
        didTapAddButton?()
    }
}
