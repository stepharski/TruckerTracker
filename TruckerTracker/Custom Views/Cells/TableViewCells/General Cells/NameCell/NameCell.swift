//
//  NameCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/24/23.
//

import UIKit

// TODO: Rename to ItemNameCell !!!
class NameCell: UITableViewCell {

    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var nameTextField: UITextField!
    
    var nameDidChange: ((String) -> Void)?
    
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    var titleImage: UIImage? {
        didSet { titleImageView.image = titleImage }
    }
    
    var name: String? {
        didSet { nameTextField.text = name }
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
        nameTextField.becomeFirstResponder()
    }
    
    private func configureTextField() {
        nameTextField.delegate = self
        nameTextField.tintColor = .label
        nameTextField.returnKeyType = .done
        nameTextField.autocapitalizationType = .sentences
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // NameDidChange
    @objc private func textFieldDidChange() {
        guard let newName = nameTextField.text else { return }
        nameDidChange?(newName)
    }
}

// MARK: - UITextFieldDelegate
extension NameCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}
