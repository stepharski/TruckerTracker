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
    
    var dieselAmountDidChange: ((Double) -> Void)?
    var defAmountDidChange: ((Double) -> Void)?
    var reeferAmountDidChange: ((Double) -> Void)?
    
    var item: FuelViewModelItem? {
        didSet {
            if let dieselItem = item as? FuelViewModelDieselItem {
                fuelImageView.image = dieselItem.image
                fuelTitleLabel.text = dieselItem.title
                fuelAmountTextField.amount = dieselItem.amount.formattedString
                
            } else if let defItem = item as? FuelViewModelDefItem {
                fuelImageView.image = defItem.image
                fuelTitleLabel.text = defItem.title
                fuelAmountTextField.amount = defItem.amount.formattedString
                
            } else if let reeferItem = item as? FuelViewModelReeferItem {
                fuelImageView.image = reeferItem.image
                fuelTitleLabel.text = reeferItem.title
                fuelAmountTextField.amount = reeferItem.amount.formattedString
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
    func activateTextField() {
        fuelAmountTextField.becomeFirstResponder()
    }
    
    private func configureTextField() {
        fuelAmountTextField.containsCurrency = true
        fuelAmountTextField.fontWeight = .medium
        fuelAmountTextField.amountAttrFontSize = 17
        fuelAmountTextField.currencyAttrFontSize = 14
        
        fuelAmountTextField.amountDidChange = { [weak self] amount in
            if self?.item is FuelViewModelDieselItem {
                self?.dieselAmountDidChange?(amount)
                
            } else if self?.item is FuelViewModelDefItem {
                self?.defAmountDidChange?(amount)
                
            } else if self?.item is FuelViewModelReeferItem {
                self?.reeferAmountDidChange?(amount)
            }
        }
    }
}
