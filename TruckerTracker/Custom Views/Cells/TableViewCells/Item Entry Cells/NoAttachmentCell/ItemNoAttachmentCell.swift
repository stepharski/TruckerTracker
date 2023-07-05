//
//  ItemNoAttachmentCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/27/23.
//

import UIKit

class ItemNoAttachmentCell: UITableViewCell {

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
