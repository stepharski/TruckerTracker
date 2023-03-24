//
//  ItemDateCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/24/23.
//

import UIKit

class ItemDateCell: UITableViewCell {

    @IBOutlet private var dateImageView: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    
    var dateDidChange: ((Date) -> Void)?
    
    var date: Date? {
        didSet {
            guard let date = date else { return }
            dateLabel.text = Calendar.current.isDateInToday(date) ? "Today"
                                        : date.convertToMonthDayFormat()
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
        guard let date = self.date else { return }
        dateDidChange?(date.addNumberOfDays(-1))
    }
    
    @IBAction private func nextDate(_ sender: UIButton) {
        guard let date = self.date else { return }
        dateDidChange?(date.addNumberOfDays(1))
    }
}
