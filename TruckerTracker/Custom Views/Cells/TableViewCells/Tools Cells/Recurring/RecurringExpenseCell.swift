//
//  RecurringExpenseCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/22/23.
//

import UIKit

class RecurringExpenseCell: UITableViewCell {

    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0,
                                                             bottom: 10, right: 0))
    }
    
    // Configuration
    private func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
    }
    
    func configure(image: UIImage?, title: String, subtitle: String, amountText: String) {
        titleImageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
        amountLabel.text = amountText
    }
}
