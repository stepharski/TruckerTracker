//
//  DriverNameCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/14/23.
//

import UIKit

class DriverNameCell: UITableViewCell {

    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var inputTextfield: UITextField!
    
    var inputDidChange: ((String) -> Void)?
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        configureTextField()
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0,
                                                             bottom: 15, right: 0))
    }

    // Configuration
    private func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
    }
    
    func configure(image: UIImage?, title: String?, input: String?) {
        titleImageView.image = image
        titleLabel.text = title
        inputTextfield.text = input
    }
    
    // TextField
    func activateTextField() {
        inputTextfield.becomeFirstResponder()
    }
    
    private func configureTextField() {
        inputTextfield.delegate = self
        inputTextfield.tintColor = .label
        inputTextfield.returnKeyType = .done
        inputTextfield.autocapitalizationType = .words
        inputTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // InputDidChange
    @objc private func textFieldDidChange() {
        guard let newInput = inputTextfield.text else { return }
        inputDidChange?(newInput)
    }
}

// MARK: - UITextField Delegate
extension DriverNameCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextfield.resignFirstResponder()
        return true
    }
}
