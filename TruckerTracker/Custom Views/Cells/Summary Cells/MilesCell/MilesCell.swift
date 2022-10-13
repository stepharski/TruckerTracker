//
//  MilesCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/1/22.
//

import UIKit

class MilesCell: UITableViewCell {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var startLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: NSLayoutConstraint!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }    
}
