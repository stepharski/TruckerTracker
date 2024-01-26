//
//  PeriodDisplayViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/2/23.
//

import UIKit

// MARK: - PeriodDisplay Delegate
protocol PeriodDisplayDelegate: AnyObject {
    func didTapPeriod()
    func didUpdatePeriod(with newPeriod: Period)
}

// MARK: - PeriodDisplay ViewController
class PeriodDisplayViewController: UIViewController {
    
    weak var delegate: PeriodDisplayDelegate?

    let periodFontSize: CGFloat = 17
    let numberOfItemFontSize: CGFloat = 14
    
    private let periodlabel = UILabel()
    private let numberOfItemsLabel = UILabel()
    
    private let nextButton = UIButton()
    private let previousButton = UIButton()
    
    var period: Period = Period.getDefault() {
        didSet { updatePeriodLabel() }
    }
    
    var numberOfItems: Int = 0 {
        didSet { updateNumberOfItemsLabel() }}
    
    var itemName: String = "item" {
        didSet { updateNumberOfItemsLabel() }}
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addTapToBackground()
        configureLabels()
        configureButtons()
        updatePeriodLabel()
        updateNumberOfItemsLabel()
    }
    
    // Background tap
    private func addTapToBackground() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapBackground() {
        delegate?.didTapPeriod()
    }
    
    // Labels
    private func configureLabels() {
        [periodlabel, numberOfItemsLabel].forEach {
            view.addSubview($0)
            $0.textColor = .label
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        periodlabel.font = UIFont.systemFont(ofSize: periodFontSize, weight: .semibold)
        numberOfItemsLabel.font = UIFont.systemFont(ofSize: numberOfItemFontSize, weight: .semibold)
        
        NSLayoutConstraint.activate([
            periodlabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            periodlabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            
            numberOfItemsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numberOfItemsLabel.topAnchor.constraint(equalTo: periodlabel.bottomAnchor, constant: 3)
        ])
    }
    
    private func updatePeriodLabel() {
        periodlabel.text = period.convertToString()
    }
    
    private func updateNumberOfItemsLabel() {
        numberOfItemsLabel.text = "\(numberOfItems) \(itemName)" + (numberOfItems == 1 ? "" : "s")
    }
    
    // Buttons
    private func configureButtons() {
        [nextButton, previousButton].forEach {
            view.addSubview($0)
            $0.imageView?.tintColor = .label
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nextButton.setImage(SFSymbols.arrowCompactRight, for: .normal)
        previousButton.setImage(SFSymbols.arrowCompactLeft, for: .normal)
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: view.topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor, multiplier: 3/4),
            
            previousButton.topAnchor.constraint(equalTo: view.topAnchor),
            previousButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previousButton.widthAnchor.constraint(equalTo: previousButton.heightAnchor, multiplier: 3/4)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
    }
    
    // Period Update
    // Next
    @objc private func nextButtonTapped() {
        switch period.type {
        case .year:
            period.interval = period.interval.nextYearInterval()
            
        case .month:
            period.interval = period.interval.nextMonthInterval()
            
        case .week, .customPeriod, .sinceYouStarted:
            period.interval = period.interval.nextInterval()
        }
        
        delegate?.didUpdatePeriod(with: period)
    }
    
    // Previous
    @objc private func previousButtonTapped() {
        switch period.type {
        case .year:
            period.interval = period.interval.previousYearInterval()
            
        case .month:
            period.interval = period.interval.previousMonthInterval()
            
        case .week, .customPeriod, .sinceYouStarted:
            period.interval = period.interval.previousInterval()
        }
        
        delegate?.didUpdatePeriod(with: period)
    }
}
