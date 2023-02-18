//
//  RecurringExpenseCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/25/22.
//

import UIKit

class RecurringExpenseCell: UITableViewCell {
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var frequencyLabel: UILabel!
    
    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    
    var amount: Int = 0 {
        didSet {
            amountLabel.text = "$\(amount)"
        }
    }
    
    var frequency: FrequencyType = .never {
        didSet {
            frequencyLabel.text = frequency.title
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
