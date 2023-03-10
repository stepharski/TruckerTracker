//
//  DateCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/8/23.
//

import UIKit

class DateCell: UITableViewCell {

    @IBOutlet private var dateImageView: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    
    var item: LoadViewModelItem? {
        didSet {
            if let dateItem = item as? LoadViewModelDateItem {
                dateLabel.text = dateItem.title
            }
        }
    }
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    // @IBAction
    @IBAction private func previousDate(_ sender: UIButton) {
        updateDate(isNextDay: false)
    }
    
    @IBAction private func nextDate(_ sender: UIButton) {
        updateDate(isNextDay: true)
    }
    
    // Update VM
    func updateDate(isNextDay: Bool) {
        if let dateItem = item as? LoadViewModelDateItem {
            let newDate = dateItem.date.addNumberOfDays(isNextDay ? 1 : -1)
            dateItem.date = newDate
            item = dateItem
        }
    }
}
