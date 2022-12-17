//
//  TRItemCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/15/22.
//

import UIKit

class TRItemCell: UITableViewCell {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    
    var itemName: String? {
        didSet {
            nameLabel.text = itemName
        }
    }
    
    var itemValue: String? {
        didSet {
            valueLabel.text = itemValue
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
