//
//  SettingToggleCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/24/23.
//

import UIKit

class SettingToggleCell: UITableViewCell {
    
    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var toggleSwitch: UISwitch!
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        selectionStyle = .none
        backgroundColor = .clear
        toggleSwitch.isOn = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0,
                                                             bottom: 15, right: 0))
    }
    
    // @IBAction
    @IBAction private func toggleSwitchValueChanged(_ sender: UISwitch) {
        //TODO: Handle switch
    }
    
    // Configuration
    private func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
    }
    
    func configure(image: UIImage?, title: String?, isToggleOn: Bool = false) {
        titleImageView.image = image
        titleLabel.text = title
        toggleSwitch.isOn = isToggleOn
    }
}
