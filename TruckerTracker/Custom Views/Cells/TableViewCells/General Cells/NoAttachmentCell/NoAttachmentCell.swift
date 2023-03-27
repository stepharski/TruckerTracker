//
//  NoAttachmentCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/27/23.
//

import UIKit

class NoAttachmentCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }
}
