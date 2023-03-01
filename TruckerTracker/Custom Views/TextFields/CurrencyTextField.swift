//
//  CurrencyTextField.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import UIKit

class CurrencyTextField: UITextField {

    private var amount = "0"
    private var formatter = NumberFormatter()
    
    var maxDigits: Int = 10
    var amountFontSize: CGFloat = 36
    var currencyFontSize: CGFloat = 24
    
    lazy var currencySign: String = {
        return UDManager.shared.getCurrencyType().symbol
    }()
    
    var amountDidChange: ((Double) -> Void)?

    // Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // Disable copy/paste
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(copy(_:)), #selector(paste(_:)),
            #selector(select(_:)), #selector(selectAll(_:)):
            return false
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    // Enables editing only at the end position
    override func caretRect(for position: UITextPosition) -> CGRect {
        let endPosition = self.endOfDocument
        return super.caretRect(for: endPosition)
    }
    
    // Deletion
    override func deleteBackward() {
        amount = amount.count < 2 ? "0" : String(amount.dropLast())
        attributedText = addCurrency(to: amount)
        amountDidChange?(Double(amount) ?? 0)
    }
    
    // Configuration
    private func setup() {
        tintColor = .clear
        keyboardType = .decimalPad
        formatter.locale = .current
        attributedText = addCurrency(to: amount)
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    // Handle entry
    @objc func textFieldDidChange() {
        guard let text = self.text, let lastEntry = text.last else { return }
        
        let decimalSeparator = formatter.decimalSeparator ?? "."
        let allowedCharacters = "0123456789\(decimalSeparator)"
        
        if amount.count < maxDigits,
           !(amount == "0" && lastEntry == "0"),
            text.count(of: decimalSeparator) < 2,
               amount.numberOfCharacters(after: decimalSeparator) < 2,
                               allowedCharacters.contains(lastEntry) {
            
            if amount == "0" && lastEntry.isNumber {
                amount = String(lastEntry)
            } else {
                amount.append(lastEntry)
            }
        }
        
        attributedText = addCurrency(to: amount)
        amountDidChange?(Double(amount) ?? 0)
    }
    
    // Format entry
    func addCurrency(to amount: String) -> NSMutableAttributedString {
        let currencyAttributes = [NSAttributedString.Key.font:
                                UIFont.systemFont(ofSize: currencyFontSize, weight: .semibold)]
        let amountAttributes = [NSAttributedString.Key.font:
                                UIFont.systemFont(ofSize: amountFontSize, weight: .semibold)]
        
        let currencyString = NSMutableAttributedString(string: "\(currencySign) ",
                                                   attributes: currencyAttributes)
        let amountString = NSAttributedString(string: amount.isEmpty ? "0" : amount,
                                              attributes: amountAttributes)
        currencyString.append(amountString)
        return currencyString
    }
}
