//
//  DistanceCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit

class DistanceCell: UITableViewCell {

    @IBOutlet private var distanceImageView: UIImageView!
    @IBOutlet private var distanceTitleLabel: UILabel!
    @IBOutlet private var distanceTextField: AmountTextField!
    @IBOutlet private var distanceAbbreviationLabel: UILabel!
    
    var item: LoadViewModelItem? {
        didSet {
            if let tripDistanceItem = item as? LoadViewModelTripDistanceItem {
                distanceImageView.image = tripDistanceItem.image
                distanceTitleLabel.text = tripDistanceItem.title
                distanceTextField.text = "\(tripDistanceItem.distance)"
                distanceAbbreviationLabel.text = tripDistanceItem.distanceAbbreviation
                
            } else if let emptyDistanceItem = item as? LoadViewModelEmptyDistanceItem {
                distanceImageView.image = emptyDistanceItem.image
                distanceTitleLabel.text = emptyDistanceItem.title
                distanceTextField.text = "\(emptyDistanceItem.distance)"
                distanceAbbreviationLabel.text = emptyDistanceItem.distanceAbbreviation
            }
        }
    }
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureTextField()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    // TextField
    func configureTextField() {
        distanceTextField.isDecimalPad = false
        
        distanceTextField.amountDidChange = { amount in
            // Update VM
            if let tripDistanceItem = self.item as? LoadViewModelTripDistanceItem {
                tripDistanceItem.distance = Int(amount)
                
            } else if let emptyDistanceItem = self.item as? LoadViewModelEmptyDistanceItem {
                emptyDistanceItem.distance = Int(amount)
            }
        }
    }
    
    func activateTextField() {
        distanceTextField.becomeFirstResponder()
    }
}
