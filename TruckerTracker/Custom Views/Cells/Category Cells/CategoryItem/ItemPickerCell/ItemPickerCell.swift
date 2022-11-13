//
//  ItemPickerCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/23/22.
//

import UIKit

class ItemPickerCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueTextField: UITextField!
    
    var pickerName: String? {
        didSet {
            nameLabel.text = pickerName
        }
    }
    
    var pickerValue: String? {
        didSet {
            valueTextField.text = pickerValue
        }
    }
    
    var pickerTextFieldPressed: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        valueTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate
extension ItemPickerCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerTextFieldPressed?()
        return false
    }
}
