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
    
    private var section: LoadTableSection?
    
    var startLocationDidChange: ((String) -> Void)?
    var endLocationDidChange: ((String) -> Void)?
    var didTapGetCurrentLocation: ((LoadTableSectionType) -> Void)?
    
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureTextField()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    // @IBAction
    @IBAction private func getCurrentLocation(_ sender: UIButton) {
        if section is LoadTableStartLocationSection {
            didTapGetCurrentLocation?(.startLocation)
            
        } else if section is LoadTableEndLocationSection {
            didTapGetCurrentLocation?(.endLocation)
        }
    }
    
    // Configuration
    func configure(for section: LoadTableSection) {
        self.section = section
        if let startLocationSection = section as? LoadTableStartLocationSection {
            underlineView.isHidden = true
            directionLabel.text = startLocationSection.title
            locationTextField.text = startLocationSection.startLocation
            
        } else if let endLocationSection = section as? LoadTableEndLocationSection {
            underlineView.isHidden = false
            directionLabel.text = endLocationSection.title
            locationTextField.text = endLocationSection.endLocation
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
        
        if section is LoadTableStartLocationSection {
            startLocationDidChange?(newLocation)
            
        } else if section is LoadTableEndLocationSection {
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
