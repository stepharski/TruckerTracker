//
//  ExportPeriodCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/30/22.
//

import UIKit

class ExportPeriodCell: UITableViewCell {
    
    @IBOutlet private var fromDateLabel: UILabel!
    @IBOutlet private var toDateLabel: UILabel!
    
    var startDate: Date? {
        didSet {
            if let date = startDate {
                fromDateLabel.text = "\(date.convertToMonthDayYearFormat())"
            }
        }
    }
    
    var endDate: Date? {
        didSet {
            if let date = endDate {
                toDateLabel.text = "\(date.convertToMonthDayYearFormat())"
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
