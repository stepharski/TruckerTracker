//
//  ResetOptionCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/30/22.
//

import UIKit

class ResetOptionCell: UITableViewCell {

    @IBOutlet private var checkBoxView: UIView!
    @IBOutlet private var checkmarkImageView: UIImageView!
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    var optionTitle: String? {
        didSet { titleLabel.text = optionTitle }
    }
    
    var optionDescription: String? {
        didSet { descriptionLabel.text = optionDescription }
    }
    
    var optionIsSelected: Bool = true {
        didSet {
            updateLabels()
            updateCheckBox()
        }
    }
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        checkBoxView.roundEdges(by: 5)
    }
    
    
    private func updateLabels() {
        titleLabel.textColor = optionIsSelected ? .label : .systemGray
        descriptionLabel.textColor = optionIsSelected ? .label : .systemGray
    }
    
    private func updateCheckBox() {
        checkmarkImageView.isHidden = !optionIsSelected
        checkBoxView.backgroundColor = optionIsSelected ? .label : .systemGray4
    }
}
