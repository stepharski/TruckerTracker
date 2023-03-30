//
//  LoadCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/17/23.
//

import UIKit

class LoadCell: UITableViewCell {

    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var milesLabel: UILabel!
    @IBOutlet private var amountLabel: UILabel!
    
    @IBOutlet private var startLocationLabel: UILabel!
    @IBOutlet private var endLocationLabel: UILabel!
    
    @IBOutlet private var startLocationView: UIView!
    @IBOutlet private var endLocationView: UIView!
    
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
    func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
        startLocationView.roundEdges(by: 5)
        endLocationView.roundEdges(by: 5)
    }
    
    func configure(with viewModel: LoadCellViewModel) {
        dateLabel.text = viewModel.date
        milesLabel.text = viewModel.distance
        amountLabel.text = viewModel.amount
        startLocationLabel.text = viewModel.startLocation
        endLocationLabel.text = viewModel.endLocation
    }
}
