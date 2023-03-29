//
//  LoadLocationCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/10/23.
//

import UIKit

class LoadLocationCell: UITableViewCell {

    @IBOutlet private var directionLabel: UILabel!
    @IBOutlet private var locationTextField: UITextField!
    @IBOutlet private var underlineView: UIView!
    
    var startLocationDidChange: ((String) -> Void)?
    var endLocationDidChange: ((String) -> Void)?
    
    var didTapGetCurrentLocation: ((LoadLocationType) -> Void)?
    
    var item: LoadViewModelItem? {
        didSet {
            if let startLocationItem = item as? LoadViewModelStartLocationItem {
                underlineView.isHidden = true
                directionLabel.text = startLocationItem.title
                locationTextField.text = startLocationItem.startLocation
                
            } else if let endLocationItem = item as? LoadViewModelEndLocationItem {
                underlineView.isHidden = false
                directionLabel.text = endLocationItem.title
                locationTextField.text = endLocationItem.endLocation
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
        if item is LoadViewModelStartLocationItem {
            didTapGetCurrentLocation?(.start)
            
        } else if item is LoadViewModelEndLocationItem {
            didTapGetCurrentLocation?(.end)
        }
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
        
        if item is LoadViewModelStartLocationItem {
            startLocationDidChange?(newLocation)
            
        } else if item is LoadViewModelEndLocationItem {
            endLocationDidChange?(newLocation)
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoadLocationCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        return true
    }
}
