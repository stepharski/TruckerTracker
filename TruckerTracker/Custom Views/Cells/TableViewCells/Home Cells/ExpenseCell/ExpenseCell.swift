//
//  ExpenseCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/17/23.
//

import UIKit

class ExpenseCell: UITableViewCell {

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var frequencyImageView: UIImageView!
    
    @IBOutlet private var frequencyLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    
    @IBOutlet private var amountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        configureUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0,
                                                             bottom: 15, right: 0))
    }
    
    
    func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
    }
}
