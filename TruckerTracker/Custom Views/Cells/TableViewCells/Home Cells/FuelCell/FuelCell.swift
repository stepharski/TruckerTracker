//
//  FuelCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import UIKit

class FuelCell: UITableViewCell {

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var fuelTitleLabel: UILabel!
    @IBOutlet private var fuelImageView: UIImageView!
    
    // Life cycle
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

    // Configuration
    func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
    }
    
    func configure(with viewModel: FuelCellViewModel) {
        dateLabel.text = viewModel.date
        amountLabel.text = viewModel.amount
        locationLabel.text = viewModel.location
        fuelTitleLabel.text = viewModel.title
        fuelImageView.image = viewModel.fuelImage
    }
}
