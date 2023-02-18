//
//  ProfileMenuCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/14/22.
//

import UIKit

class ProfileMenuCell: UICollectionViewCell {
    
    @IBOutlet private weak var settingImageView: UIImageView!
    @IBOutlet private weak var settingTitle: UILabel!
    @IBOutlet private weak var settingSubtitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roundEdges()
        dropShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !(layer.sublayers?.first is CAGradientLayer) {
            self.applyGradient(colors: [#colorLiteral(red: 0.1529411765, green: 0.3294117647, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.02352941176, green: 0.03137254902, blue: 0.02745098039, alpha: 1)], locations: [0, 1])
        }
    }
    
    
    public func configure(with image: UIImage?, title: String, subtitle: String) {
        settingImageView.image = image
        settingTitle.text = title
        settingSubtitle.text = subtitle
    }
}
