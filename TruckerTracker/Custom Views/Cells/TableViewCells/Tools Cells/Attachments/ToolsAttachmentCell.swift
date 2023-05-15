//
//  ToolsAttachmentCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/15/23.
//

import UIKit

class ToolsAttachmentCell: UITableViewCell {

    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0,
                                                             bottom: 15, right: 0))
    }
    
    // Configuration
    private func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
    }
    
    func configure(image: UIImage?, title: String, subtitle: String) {
        titleImageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
