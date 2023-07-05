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
    
    var frequencyImage: UIImage? {
        didSet { frequencyImageView.image = frequencyImage }
    }
    
    var frequencyTitle: String? {
        didSet { frequencyLabel.text = frequencyTitle }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
