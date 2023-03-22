//
//  AddDocumentView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/19/23.
//

import UIKit

class AddDocumentView: UIView {
    
    private let addDocButton = UIButton()
    
    var didTapAddButton: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAddDocButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureAddDocButton() {
        var config = UIButton.Configuration.plain()
        config.image = SFSymbols.plusRectOnRect
        config.baseForegroundColor = .label
        addDocButton.configuration = config
        
        addSubview(addDocButton)
        addDocButton.addTarget(self, action: #selector(addDocAction), for: .touchUpInside)
        
        addDocButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addDocButton.widthAnchor.constraint(equalToConstant: 45),
            addDocButton.heightAnchor.constraint(equalToConstant: 45),
            addDocButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addDocButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc func addDocAction() {
        didTapAddButton?()
    }
}
