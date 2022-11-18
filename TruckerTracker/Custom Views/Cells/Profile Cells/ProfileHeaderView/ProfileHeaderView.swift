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
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindGestures()
        configureAvatarImage()
        configurePlusButton()
        backgroundColor = .clear
    }
    
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        changeAvatar()
    }
    
    func bindGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func changeAvatar() {
        print("Change Avatar")
    }
    
    
    private func configureAvatarImage() {
        backgroundColor = .clear
        avatarImageView.roundEdges(by: 50)
        avatarBackgroundView.roundEdges(by: 50)
        avatarBackgroundView.dropShadow(color: .white, size: .zero)
    }
    
    private func configurePlusButton() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.image = SFSymbols.plus?
                .withConfiguration(UIImage.SymbolConfiguration(scale: .small))
        config.baseBackgroundColor = #colorLiteral(red: 0.07450980392, green: 0.1450980392, blue: 0.1254901961, alpha: 1)
        config.baseForegroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        config.background.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        config.background.strokeWidth = 1.0
        plusButton.configuration = config
    }
}
