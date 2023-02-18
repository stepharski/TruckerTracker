//
//  ExpensesCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/1/22.
//

import UIKit

class ExpensesCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
