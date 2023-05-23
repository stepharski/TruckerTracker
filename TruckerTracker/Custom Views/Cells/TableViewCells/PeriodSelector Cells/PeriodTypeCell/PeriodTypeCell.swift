//
//  PeriodTypeCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/20/23.
//

import UIKit

class PeriodTypeCell: UITableViewCell {
    
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var checkMarkLabel: UILabel!
    @IBOutlet private var highlightedBackgroundView: UIView!
    
    var typeTitle: String? {
        didSet {
            typeLabel.text = typeTitle
        }
    }
    
    var isTypeSelected: Bool = false {
        didSet {
            checkMarkLabel.isHidden = !isTypeSelected
            highlightedBackgroundView.backgroundColor = isTypeSelected ? .systemGray5 : .clear
        }
    }
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        highlightedBackgroundView.roundEdges(by: 10)
    }
}
