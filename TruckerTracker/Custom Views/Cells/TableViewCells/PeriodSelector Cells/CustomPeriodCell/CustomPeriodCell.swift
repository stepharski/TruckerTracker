//
//  CustomPeriodCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/29/23.
//

import UIKit

// MARK: - CustomPeriodCellDelegate
protocol CustomPeriodCellDelegate: AnyObject {
    func didSelect(startDate: Date, endDate: Date)
}

// MARK: - CustomPeriodCell
class CustomPeriodCell: UITableViewCell {
    
    weak var delegate: CustomPeriodCellDelegate?
    
    private let backgroundPlaceholder = UIView()
    private let dashLabel = UILabel()
    private let fromLabel = UILabel()
    private let toLabel = UILabel()
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    var startDate = Date() {
        didSet {
            startDatePicker.date = startDate
        }
    }
    
    var endDate = Date()  {
        didSet {
            endDatePicker.date = endDate
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        configureBackgroundPlaceholder()
        configurePickers()
        configureLabels()
    }
    
    
    // Configuration
    func configureBackgroundPlaceholder() {
        addSubview(backgroundPlaceholder)
        backgroundPlaceholder.roundEdges(by: 10)
        backgroundPlaceholder.backgroundColor = .systemGray5
        backgroundPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        backgroundPlaceholder.pinToEdges(of: self)
    }
    
    func configureLabels() {
        [dashLabel, fromLabel, toLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
        
        dashLabel.text = "－"
        fromLabel.text = "From"
        toLabel.text = "To"
        
        NSLayoutConstraint.activate([
            dashLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dashLabel.centerYAnchor.constraint(equalTo: startDatePicker.centerYAnchor),
            
            fromLabel.leadingAnchor.constraint(equalTo: startDatePicker.leadingAnchor),
            fromLabel.bottomAnchor.constraint(equalTo: startDatePicker.topAnchor, constant: -15),
            
            toLabel.leadingAnchor.constraint(equalTo: endDatePicker.leadingAnchor),
            toLabel.bottomAnchor.constraint(equalTo: endDatePicker.topAnchor, constant: -15)
        ])
    }
    
    func configurePickers() {
        [startDatePicker, endDatePicker].forEach {
            addSubview($0)
            $0.datePickerMode = .date
            $0.timeZone = TimeZone(secondsFromGMT: 0)
            $0.preferredDatePickerStyle = .compact
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
        
        let yAnchor: CGFloat = 15
        let xAnchor: CGFloat = self.bounds.width / 4
        NSLayoutConstraint.activate([
            startDatePicker.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yAnchor),
            startDatePicker.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -xAnchor),
            
            endDatePicker.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yAnchor),
            endDatePicker.centerXAnchor.constraint(equalTo: centerXAnchor, constant: xAnchor)
        ])
    }
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender == startDatePicker {
            startDate = sender.date
            endDate = startDate > endDate ? startDate : endDate
            
        } else if sender == endDatePicker {
            endDate = sender.date
            startDate = endDate < startDate ? endDate : startDate
        }
        
        delegate?.didSelect(startDate: startDate, endDate: endDate)
    }
}
