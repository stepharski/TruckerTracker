//
//  SortOptionCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/22/23.
//

import UIKit

class SortOptionCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var checkmarkLabel: UILabel!
    @IBOutlet private var highlightedBackgroundView: UIView!
    
    var optionTitle: String? {
        didSet { titleLabel.text = optionTitle }
    }
    
    var isOptionSelected: Bool = false {
        didSet {
            checkmarkLabel.isHidden = !isOptionSelected
            highlightedBackgroundView.backgroundColor = isOptionSelected ? .systemGray5 : .clear
        }
    }
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        highlightedBackgroundView.roundEdges(by: 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0,
                                                             bottom: 5, right: 0))
    }
}
