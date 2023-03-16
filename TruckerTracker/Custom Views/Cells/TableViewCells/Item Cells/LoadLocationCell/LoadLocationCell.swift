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
    
    var location: String? {
        didSet { locationTextField.text = location }
    }
    
    var didTapGetCurrentLocation: ((LocationType) -> Void)?
    
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
            didTapGetCurrentLocation?(.loadStart)
            
        } else if item is LoadViewModelEndLocationItem {
            didTapGetCurrentLocation?(.loadEnd)
        }
    }
    
    // TextField
    func activateTextField() {
        locationTextField.becomeFirstResponder()
    }
    
    func configureTextField() {
        locationTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // Update VM
    @objc func textFieldDidChange() {
        guard let location = locationTextField.text else { return }
        
        if let startLocationItem = item as? LoadViewModelStartLocationItem {
            startLocationItem.startLocation = location
            
        } else if let endLocationItem = item as? LoadViewModelEndLocationItem {
            endLocationItem.endLocation = location
        }
    }
}
