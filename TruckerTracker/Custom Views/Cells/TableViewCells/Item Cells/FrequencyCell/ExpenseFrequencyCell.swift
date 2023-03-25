//
//  ExpenseFrequencyCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/24/23.
//

import UIKit

class ExpenseFrequencyCell: UITableViewCell {
    
    @IBOutlet private var frequencyImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var frequencyLabel: UILabel!
    
    var item: ExpenseViewModelItem? {
        didSet {
            if let frequencyItem = item as? ExpenseViewModelFrequencyItem {
                frequencyImageView.image = frequencyItem.frequency.image
                frequencyLabel.text = frequencyItem.frequency.title
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
