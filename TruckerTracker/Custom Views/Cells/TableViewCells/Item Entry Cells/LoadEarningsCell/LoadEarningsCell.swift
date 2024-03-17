//
//  LoadEarningsCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/8/24.
//

import UIKit

class LoadEarningsCell: UITableViewCell {

    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var percentageLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    
    var percentage: Int? {
        didSet { percentageLabel.text = "\(percentage ?? 0)%" }
    }
    
    var amount: Double? {
        didSet {
            if let formattedAmount = amount?.formattedWithSeparator() {
                let currency = UDManager.shared.currency.symbol
                amountLabel.text = "\(currency)\(formattedAmount)"
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
