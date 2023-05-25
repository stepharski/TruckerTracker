//
//  FilterOptionCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/24/23.
//

import UIKit

class FilterOptionCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var checkBoxView: UIView!
    @IBOutlet private var checkMarkImageView: UIImageView!
    
    var optionTitle: String? {
        didSet { titleLabel.text = optionTitle }
    }
    
    var isOptionSelected: Bool = true {
        didSet {
            checkMarkImageView.isHidden = !isOptionSelected
            titleLabel.textColor = isOptionSelected ? .label : .systemGray2
            checkBoxView.backgroundColor = isOptionSelected ? .label : .systemGray5
        }
    }
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        checkBoxView.roundEdges(by: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0,
                                                             bottom: 5, right: 0))
    }
}
