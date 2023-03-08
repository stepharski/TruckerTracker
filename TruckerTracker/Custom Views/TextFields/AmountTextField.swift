//
//  AmountTextField.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/8/23.
//

import UIKit

class AmountTextField: UITextField {

    private var amount = "0"
    private var formatter = NumberFormatter()
    
    var maxDigits: Int = 10
    
    var amountAttrFontSize: CGFloat = 36
    var currencyAttrFontSize: CGFloat = 24
    
    var containsCurrency: Bool = false {
        didSet { updateTextField(with: amount) }
    }
    
    var maxCursorPosition: Int {
        return containsCurrency ? 3 : 1
    }
    
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
    
    // Moves cursor to the end position
    override func caretRect(for position: UITextPosition) -> CGRect {
        let endPosition = self.endOfDocument
        return super.caretRect(for: endPosition)
    }
    
    // Deletion
    override func deleteBackward() {
        amount = amount.count < 2 ? "0" : String(amount.dropLast())
        updateTextField(with: amount)
        amountDidChange?(Double(amount) ?? 0)
    }
    
    // Configuration
    private func setup() {
        tintColor = textColor
        keyboardType = .decimalPad
        formatter.locale = .current
        updateTextField(with: amount)
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // Handle entry
    @objc func textFieldDidChange() {
        guard let text = self.text, var lastEntry = text.last,
                    let selectedRange = selectedTextRange else { return }
        
        let cursorPosition = offset(from: beginningOfDocument, to: selectedRange.start)
        
        // Beginnig of document
        if cursorPosition <= maxCursorPosition, let firstCharacter = text.digits.first {
            lastEntry = firstCharacter
        }
        
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
        
        updateTextField(with: amount)
        amountDidChange?(Double(amount) ?? 0)
    }
    
    // Update text field
    func updateTextField(with amount: String) {
        if containsCurrency {
            attributedText = addCurrency(to: amount)
        } else {
            text = amount
        }
    }
    
    // Format entry
    func addCurrency(to amount: String) -> NSMutableAttributedString {
        let currencyAttributes = [NSAttributedString.Key.font:
                                UIFont.systemFont(ofSize: currencyAttrFontSize, weight: .semibold)]
        let amountAttributes = [NSAttributedString.Key.font:
                                UIFont.systemFont(ofSize: amountAttrFontSize, weight: .semibold)]
        
        let currencyString = NSMutableAttributedString(string: "\(currencySign) ",
                                                   attributes: currencyAttributes)
        let amountString = NSAttributedString(string: amount.isEmpty ? "0" : amount,
                                              attributes: amountAttributes)
        currencyString.append(amountString)
        return currencyString
    }
}
