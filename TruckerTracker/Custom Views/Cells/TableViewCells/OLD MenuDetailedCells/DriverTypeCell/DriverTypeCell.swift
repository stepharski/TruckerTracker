//
//  DriverTypeCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/16/22.
//

import UIKit

class DriverTypeCell: UITableViewCell {

    @IBOutlet private var titleImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    
    @IBOutlet private var singleButton: UIButton!
    @IBOutlet private var teamButton: UIButton!
    
    private var isTeamDriver: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.singleButton.layer.borderWidth = self.isTeamDriver ? 0 : 1
                self.teamButton.layer.borderWidth = self.isTeamDriver ? 1 : 0
            }
        }
    }
    
    var teamTypeSelected: ((_ isTeamDriver: Bool) -> ())?
    
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        configureButtons()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0,
                                                             bottom: 15, right: 0))
    }
    
    // @IBAction
    @IBAction private func didTapTeamTypeButton(_ sender: UIButton) {
        guard isTeamDriver && singleButton == sender
                || !isTeamDriver && teamButton == sender else { return }
        
        isTeamDriver =  teamButton == sender
        teamTypeSelected?(isTeamDriver)
    }
    
    // Configuration
    private func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
    }
    
    private func configureButtons() {
        [singleButton, teamButton].forEach {
            $0.layer.borderColor = UIColor.label.cgColor
            $0.layer.cornerRadius = $0.frame.height / 3
        }
    }
    
    func configure(title: String?, image: UIImage?, isTeamDriver: Bool) {
        titleLabel.text = title
        titleImageView.image = image
        self.isTeamDriver = isTeamDriver
    }
}
