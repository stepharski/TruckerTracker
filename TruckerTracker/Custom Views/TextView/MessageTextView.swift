//
//  MessageTextView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/29/23.
//

import UIKit

class MessageTextView: UITextView {
    
    var fontSize: CGFloat = 15
    var fontWeight: UIFont.Weight = .regular
    var textPadding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    // Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    
    // Setup
    private func commonSetup()  {
        self.addToolbar()
        self.isEditable = true
        self.tintColor = .label
        self.contentInset = textPadding
        self.textContainer.lineBreakMode = .byWordWrapping
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    private func addToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 45))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(image: SFSymbols.checkmark, style: .done, target: self,
                                                             action: #selector(doneButtonTapped))
        toolbar.items = [flexSpace, doneButton]
        toolbar.tintColor = .label
        toolbar.barTintColor = .systemGray5
        self.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        self.resignFirstResponder()
    }
    
    // Insets update
    func updateBottomInset(with inset: CGFloat) {
        let newInset = inset > textPadding.bottom ? inset + 25 : textPadding.bottom
        
        let updatedInsets = UIEdgeInsets(top: textPadding.top, left: textPadding.left,
                                     bottom: newInset, right: textPadding.right)
        contentInset = updatedInsets
        scrollIndicatorInsets = updatedInsets
    }
}
