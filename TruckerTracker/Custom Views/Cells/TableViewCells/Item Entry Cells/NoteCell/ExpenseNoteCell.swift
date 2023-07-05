//
//  ExpenseNoteCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/24/23.
//

import UIKit

class ExpenseNoteCell: UITableViewCell {

    @IBOutlet private var noteImageView: UIImageView!
    @IBOutlet private var noteTextField: UITextField!
    
    var noteDidChange: ((String) -> Void)?
    
    var noteText: String? {
        didSet { noteTextField.text = noteText }
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
        noteTextField.becomeFirstResponder()
    }
    
    private func configureTextField() {
        noteTextField.delegate = self
        noteTextField.tintColor = .label
        noteTextField.returnKeyType = .done
        noteTextField.autocapitalizationType = .sentences
        noteTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // NoteDidChange
    @objc private func textFieldDidChange() {
        guard let newNote = noteTextField.text else { return }
        noteDidChange?(newNote)
    }
}

// MARK: - UITextFieldDelegate
extension ExpenseNoteCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTextField.resignFirstResponder()
        return true
    }
}
