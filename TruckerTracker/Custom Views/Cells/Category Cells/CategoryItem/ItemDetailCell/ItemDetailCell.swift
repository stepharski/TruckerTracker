//
//  ItemDetailCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/17/22.
//

import UIKit

class ItemDetailCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField!
    
    var itemName: String? {
        didSet {
            nameLabel.text = itemName
        }
    }
    
    var itemValue: String? {
        didSet {
            valueTextField.text = itemValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
}
