//
//  GrossCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 9/29/22.
//

import UIKit

class GrossCell: UITableViewCell {
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var startLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
}
