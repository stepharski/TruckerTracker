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
    
    var distanceDidChange: ((Int) -> Void)?
    
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextField()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    // Configuration
    func configure(for section: LoadTableSection?) {
        guard let distanceSection = section as? LoadTableTripDistanceSection else { return }
        
        distanceTextField.text = "\(distanceSection.distance)"
        distanceAbbreviationLabel.text = distanceSection.distanceAbbreviation
    }
    
    // TextField
    func activateTextField() {
        distanceTextField.becomeFirstResponder()
    }
    
    private func configureTextField() {
        distanceTextField.isDecimalPad = false
        distanceTextField.amountDidChange = { [weak self] amount in
            self?.distanceDidChange?(Int(amount))
        }
    }
}
