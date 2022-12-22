//
//  DriverTypeCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/16/22.
//

import UIKit

class DriverTypeCell: UITableViewCell {

    @IBOutlet private var singleButton: UIButton!
    @IBOutlet private var teamButton: UIButton!
    
    @IBOutlet private var companyDriverButton: UIButton!
    @IBOutlet private var ownerOperatorButton: UIButton!
    
    var isTeamDriver: Bool = false {
        didSet {
            singleButton.isSelected = !isTeamDriver
            teamButton.isSelected = isTeamDriver
        }
    }
    
    var isOwnerOperator: Bool = true {
        didSet {
            companyDriverButton.isSelected = !isOwnerOperator
            ownerOperatorButton.isSelected = isOwnerOperator
        }
    }
    
    var teamTypeSelected: ((_ isTeamDriver: Bool) -> ())?
    var ownerTypeSelected: ((_ isOwnerOperator: Bool) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    
    @IBAction private func didTapTeamTypeButton(_ sender: UIButton) {
        guard !singleButton.isSelected && singleButton == sender
                || !teamButton.isSelected && teamButton == sender else { return }
        
        isTeamDriver =  teamButton == sender
        teamTypeSelected?(isTeamDriver)
    }
    
    @IBAction private func didTapOwnerTypeButton(_ sender: UIButton) {
        guard !companyDriverButton.isSelected && companyDriverButton == sender
                || !ownerOperatorButton.isSelected && ownerOperatorButton == sender else { return }
        
        isOwnerOperator =  ownerOperatorButton == sender
        ownerTypeSelected?(isOwnerOperator)
    }
}
