//
//  AddDocRouteCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/24/22.
//

import UIKit

enum AddCellType {
    case route, document
}

class AddDocRouteCell: UITableViewCell {

    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var underlineView: UIView!
    
    @IBAction func addDocRoute(_ sender: Any) {
        addButtonPressed?()
    }
    
    
    var addButtonPressed: (() -> Void)?
    
    var cellType: AddCellType! {
        didSet {
            switch cellType {
            case .route:
                addButton.setImage(SFSymbols.plusSquares, for: .normal)
                underlineView.isHidden = false
            case .document:
                addButton.setImage(SFSymbols.docPlus, for: .normal)
                underlineView.isHidden = true
            case .none:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
}
