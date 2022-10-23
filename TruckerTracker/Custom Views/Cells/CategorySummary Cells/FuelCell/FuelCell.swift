//
//  FuelCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/1/22.
//

import UIKit

class FuelCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fuelTypeImageView: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
}
