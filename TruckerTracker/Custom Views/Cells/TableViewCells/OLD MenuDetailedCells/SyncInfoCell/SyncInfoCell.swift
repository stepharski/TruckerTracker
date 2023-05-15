//
//  SyncInfoCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/29/22.
//

import UIKit

class SyncInfoCell: UITableViewCell {

    @IBOutlet private var infoImageView: UIImageView!
    @IBOutlet private var infoDescriptionLabel: UILabel!
    
    var infoImage: UIImage? {
        didSet {
            infoImageView.image = infoImage
        }
    }
    
    var infoDescription: String? {
        didSet {
            infoDescriptionLabel.text = infoDescription
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
