//
//  ToolCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/14/23.
//

import UIKit

class ToolCell: UICollectionViewCell {

    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        roundEdges()
        dropShadow(opacity: 0.1)
    }

    // Configuration
    func configure(with image: UIImage?, title: String, subtitle: String) {
        titleImageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
