//
//  ExpenseSummaryCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/17/23.
//

import UIKit

class ExpenseSummaryCell: UITableViewCell {

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    @IBOutlet private var frequencyLabel: UILabel!
    @IBOutlet private var frequencyImageView: UIImageView!

    
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
                                                             bottom: 15, right: 0))
    }

    // Configuration
    private func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
    }
    
    func configure(with viewModel: ExpenseSummaryViewModel) {
        dateLabel.text = viewModel.date
        nameLabel.text = viewModel.name
        amountLabel.text = viewModel.amount
        frequencyLabel.text = viewModel.frequencyTitle
        frequencyImageView.image = viewModel.frequencyImage
    }
}
