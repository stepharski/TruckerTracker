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
        didSet {
            titleLabel.text = optionTitle
        }
    }
    
    var optionDescription: String? {
        didSet {
            descriptionLabel.text = optionDescription
        }
    }
    
    var optionIsSelected: Bool = true {
        didSet {
            updateLabels()
            updateCheckBox()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        checkBoxView.roundEdges(by: 5)
    }
    
    
    private func updateLabels() {
        titleLabel.textColor = optionIsSelected ? #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1) : #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 0.8)
        descriptionLabel.textColor = optionIsSelected ? #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 0.9) : #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 0.6)
    }
    
    private func updateCheckBox() {
        checkmarkImageView.isHidden = !optionIsSelected
        checkBoxView.backgroundColor = optionIsSelected ? .black : .black.withAlphaComponent(0.8)
    }
}
