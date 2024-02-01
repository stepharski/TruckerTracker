//
//  EmptyDashListView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/31/24.
//

import UIKit

class EmptyDashListView: UIView {

    let mainImageView = UIImageView()
    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configMainImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(mainImage: UIImage) {
        self.init(frame: .zero)
        self.mainImageView.image = mainImage
    }
    
    // Configure
    private func configMainImageView() {
        addSubview(mainImageView)
        mainImageView.tintColor = .label
        mainImageView.contentMode = .scaleAspectFit
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: 75),
            mainImageView.heightAnchor.constraint(equalToConstant: 75),
            mainImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -25)
        ])
    }
}
