//
//  DateRangeView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/24/22.
//

import UIKit

class DateRangeView: UIView {

    private let nextButton = UIButton()
    private let previousButton = UIButton()
    
    private let dateRangelabel = UILabel()
    private let numberOfItemsLabel = UILabel()
    
    var startDate: Date = Date()
    var endDate: Date = Date(timeIntervalSinceNow: 60*60*24*7)
    
    var numberOfItems: Int = 15
    var itemName: String = "Document"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLabels()
        configureButtons()
        addTapToBackground()
        updateDateRangeLabel()
        updateNumberOfItemsLabel()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Background tap
    private func addTapToBackground() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapBackground() {
        //TODO: Show dateRangePicker
    }
    
    // Labels
    private func configureLabels() {
        addSubviews(dateRangelabel, numberOfItemsLabel)
        
        dateRangelabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        numberOfItemsLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        [dateRangelabel, numberOfItemsLabel].forEach {
            $0.textColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            dateRangelabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateRangelabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -7),
            
            numberOfItemsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            numberOfItemsLabel.topAnchor.constraint(equalTo: dateRangelabel.bottomAnchor, constant: 3)
        ])
    }
    
    private func updateDateRangeLabel() {
        dateRangelabel.text = "\(startDate.convertToMonthDayFormat()) — \(endDate.convertToMonthDayFormat())"
    }
    
    private func updateNumberOfItemsLabel() {
        numberOfItemsLabel.text = "\(numberOfItems) \(itemName)" + (numberOfItems == 1 ? "" : "s")
    }
    
    // Buttons
    private func configureButtons() {
        addSubviews(nextButton, previousButton)
        nextButton.setImage(SFSymbols.arrowCompactRight, for: .normal)
        previousButton.setImage(SFSymbols.arrowCompactLeft, for: .normal)
        
        [nextButton, previousButton].forEach {
            $0.imageView?.tintColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: self.topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor, multiplier: 3/4),
            
            previousButton.topAnchor.constraint(equalTo: self.topAnchor),
            previousButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            previousButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            previousButton.widthAnchor.constraint(equalTo: previousButton.heightAnchor, multiplier: 3/4)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() { }
    
    @objc private func previousButtonTapped() { }
}
