//
//  LoadDistanceCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/24/23.
//

import UIKit

class LoadDistanceCell: UITableViewCell {

    @IBOutlet private var distanceImageView: UIImageView!
    @IBOutlet private var distanceTitleLabel: UILabel!
    @IBOutlet private var distanceTextField: AmountTextField!
    @IBOutlet private var distanceAbbreviationLabel: UILabel!
    
    private var section: LoadTableSection?
    
    var emptyDistanceDidChange: ((Int) -> Void)?
    var tripDistanceDidChange: ((Int) -> Void)?
    
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextField()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    // Configuration
    func configure(for section: LoadTableSection?) {
        self.section = section
        
        if let tripDistanceSection = section as? LoadTableTripDistanceSection {
            distanceImageView.image = tripDistanceSection.image
            distanceTitleLabel.text = tripDistanceSection.title
            distanceTextField.text = "\(tripDistanceSection.distance)"
            distanceAbbreviationLabel.text = tripDistanceSection.distanceAbbreviation
            
        } else if let emptyDistanceSection = section as? LoadTableEmptyDistanceSection {
            distanceImageView.image = emptyDistanceSection.image
            distanceTitleLabel.text = emptyDistanceSection.title
            distanceTextField.text = "\(emptyDistanceSection.distance)"
            distanceAbbreviationLabel.text = emptyDistanceSection.distanceAbbreviation
        }
    }
    
    // TextField
    func activateTextField() {
        distanceTextField.becomeFirstResponder()
    }
    
    private func configureTextField() {
        distanceTextField.isDecimalPad = false
        
        distanceTextField.amountDidChange = { [weak self] amount in
            
            if self?.section is LoadTableTripDistanceSection {
                self?.tripDistanceDidChange?(Int(amount))
                
            } else if self?.section is LoadTableEmptyDistanceSection {
                self?.emptyDistanceDidChange?(Int(amount))
            }
        }
    }
}
