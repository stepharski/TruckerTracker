//
//  FuelLocationCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/28/23.
//

import UIKit

class FuelLocationCell: UITableViewCell {

    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var locationTextField: UITextField!
    
    var locationDidChange: ((String) -> Void)?
    var didTapGetCurrentLocation: (() -> Void)?
    
    var item: FuelViewModelItem? {
        didSet {
            if let locationItem = item as? FuelViewModelLocationItem {
                locationTextField.text = locationItem.location
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
    
    // @IBAction
    @IBAction private func getCurrentLocation(_ sender: UIButton) {
        didTapGetCurrentLocation?()
    }
    
    // TextField
    func activateTextField() {
        locationTextField.becomeFirstResponder()
    }
    
    private func configureTextField() {
        locationTextField.delegate = self
        locationTextField.tintColor = .label
        locationTextField.returnKeyType = .done
        locationTextField.autocapitalizationType = .words
        locationTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // LocationDidChange
    @objc private func textFieldDidChange() {
        guard let newLocation = locationTextField.text else { return }
        
        locationDidChange?(newLocation)
    }
}

// MARK - UITextFieldDelegate
extension FuelLocationCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        return true
    }
}
