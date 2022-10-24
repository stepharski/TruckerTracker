//
//  RouteCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/24/22.
//

import UIKit

enum RouteDirection: String {
    case from, to
}

class RouteCell: UITableViewCell {
    
    @IBOutlet private weak var directionLabel: UILabel!
    @IBOutlet private weak var locationTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    
    var direction: RouteDirection! {
        didSet {
            directionLabel.text = direction.rawValue.capitalized
        }
    }
    
    var location: String? {
        didSet {
            locationTextField.text = location
        }
    }
    
    var date: Date? {
        didSet {
            dateTextField.text = "\(date?.formatted(.dateTime.day().month()) ?? "Enter Location")"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }
}
