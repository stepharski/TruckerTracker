//
//  ItemAttachmentCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/27/23.
//

import UIKit

class ItemAttachmentCell: UITableViewCell {

    @IBOutlet private var attachmentImageView: UIImageView!
    @IBOutlet private var attachmentTitle: UILabel!
    
    var title: String? {
        didSet { attachmentTitle.text = title }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }
}
