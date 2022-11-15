//
//  ProfileHeaderView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/12/22.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    
    @IBOutlet private weak var avatarBackgroundView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    private func configure() {
        backgroundColor = .clear
        avatarImageView.roundEdges(by: 50)
        avatarBackgroundView.roundEdges(by: 50)
        avatarBackgroundView.dropShadow(color: .white, size: .zero)
    }
}
