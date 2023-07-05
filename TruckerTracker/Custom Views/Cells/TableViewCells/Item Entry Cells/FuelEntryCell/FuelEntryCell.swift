//
//  FuelEntryCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/28/23.
//

import UIKit

class FuelEntryCell: UITableViewCell {

    @IBOutlet private var fuelImageView: UIImageView!
    @IBOutlet private var fuelTitleLabel: UILabel!
    @IBOutlet private var fuelAmountTextField: AmountTextField!
    
    private var section: FuelTableSection?
    
    var dieselAmountDidChange: ((Double) -> Void)?
    var defAmountDidChange: ((Double) -> Void)?
    var reeferAmountDidChange: ((Double) -> Void)?

    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureTextField()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    // Configuration
    func configure(for section: FuelTableSection) {
        self.section = section
        
        if let dieselSection = section as? FuelTableDieselSection {
            fuelImageView.image = dieselSection.image
            fuelTitleLabel.text = dieselSection.title
            fuelAmountTextField.amount = dieselSection.amount.formattedString
            
        } else if let defSection = section as? FuelTableDefSection {
            fuelImageView.image = defSection.image
            fuelTitleLabel.text = defSection.title
            fuelAmountTextField.amount = defSection.amount.formattedString
            
        } else if let reeferSection = section as? FuelTableReeferSection {
            fuelImageView.image = reeferSection.image
            fuelTitleLabel.text = reeferSection.title
            fuelAmountTextField.amount = reeferSection.amount.formattedString
        }
    }
    
    // TextField
    func activateTextField() {
        fuelAmountTextField.becomeFirstResponder()
    }
    
    private func configureTextField() {
        fuelAmountTextField.containsCurrency = true
        fuelAmountTextField.fontWeight = .medium
        fuelAmountTextField.amountAttrFontSize = 17
        fuelAmountTextField.currencyAttrFontSize = 14
        
        fuelAmountTextField.amountDidChange = { [weak self] amount in
            if self?.section is FuelTableDieselSection {
                self?.dieselAmountDidChange?(amount)
                
            } else if self?.section is FuelTableDefSection {
                self?.defAmountDidChange?(amount)
                
            } else if self?.section is FuelTableReeferSection {
                self?.reeferAmountDidChange?(amount)
            }
        }
    }
}
