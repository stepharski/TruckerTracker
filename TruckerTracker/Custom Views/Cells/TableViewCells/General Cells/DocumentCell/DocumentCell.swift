//
//  DocumentCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/24/22.
//

import UIKit

class DocumentCell: UITableViewCell {

    @IBOutlet private var documentLabel: UILabel!
    
    var documentName: String? {
        didSet { documentLabel.text = documentName }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = .clear
    }
}
