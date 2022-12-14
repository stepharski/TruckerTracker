//
//  DocumentCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/24/22.
//

import UIKit

class DocumentCell: UITableViewCell {

    @IBOutlet private var docNameLabel: UILabel!
    
    var docName: String? {
        didSet {
            docNameLabel.text = docName
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
