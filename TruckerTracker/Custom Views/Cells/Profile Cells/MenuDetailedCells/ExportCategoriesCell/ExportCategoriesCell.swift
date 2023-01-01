//
//  ExportCategoriesCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/30/22.
//

import UIKit

class ExportCategoriesCell: UITableViewCell {
    
    @IBOutlet private var categoryLabels: [UILabel]!
    @IBOutlet private var categoryCheckboxes: [UIView]!
    @IBOutlet private var categoryCheckmarks: [UIImageView]!
    
    @IBOutlet private var categoryButtons: [UIButton]!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectAllCategories()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    
    @IBAction func didTapCategory(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        updateCategories()
    }
    
    func selectAllCategories() {
        categoryButtons.forEach { $0.isSelected = true }
        updateCategories()
    }
    
    func updateCategories() {
        categoryButtons.forEach { button in
            guard let index = categoryButtons.firstIndex(of: button) else { return }
            
            categoryCheckmarks[index].isHidden = !button.isSelected
            categoryLabels[index].textColor = button.isSelected ? #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1) : #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 0.6)
            categoryCheckboxes[index].backgroundColor = button.isSelected ? #colorLiteral(red: 0.01696075313, green: 0.03186775371, blue: 0.03160342947, alpha: 1) : #colorLiteral(red: 0.01960784314, green: 0.03137254902, blue: 0.03137254902, alpha: 0.8)
        }
    }
}
