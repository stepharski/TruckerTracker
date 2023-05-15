//
//  ContactCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/26/22.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var textField: ContactTextField!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    var textFieldDidChange: ((_ text: String) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        textField.delegate = self
    }
}

// MARK: - UITextFieldDelegate
extension ContactCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidChange?(textField.text ?? "")
    }
}
