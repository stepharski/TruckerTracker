//
//  SettingOptionPickerCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/24/23.
//

import UIKit

class SettingOptionPickerCell: UITableViewCell {
    
    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    
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
    
    func configure(image: UIImage?, title: String?, value: String?) {
        titleImageView.image = image
        titleLabel.text = title
        valueLabel.text = value
    }
}
