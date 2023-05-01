//
//  TRPeriodDisplayVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/2/23.
//

import UIKit

// MARK: - PeriodDisplayDelegate
protocol PeriodDisplayDelegate: AnyObject {
    func didTapPeriodDisplay()
    func displayDidUpdate(period: Period)
}

// MARK: - TRPeriodDisplayVC
class TRPeriodDisplayVC: UIViewController {
    
    weak var delegate: PeriodDisplayDelegate?

    private let nextButton = UIButton()
    private let previousButton = UIButton()
    
    private let periodlabel = UILabel()
    private let numberOfItemsLabel = UILabel()
    
    let periodFontSize: CGFloat = 17
    let numberOfItemFontSize: CGFloat = 14
    
    lazy var period: Period = {
        return UDManager.shared.period
    }() { didSet { updatePeriodLabel() }}
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkPeriodForUpdate()
    }
    
    // Background tap
    private func addTapToBackground() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapBackground() {
        delegate?.didTapPeriodDisplay()
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
    
    @objc private func nextButtonTapped() {
        period.interval = period.interval.nextInterval()
        UDManager.shared.period = period
        delegate?.displayDidUpdate(period: period)
    }
    
    @objc private func previousButtonTapped() {
        period.interval = period.interval.previousInterval()
        UDManager.shared.period = period
        delegate?.displayDidUpdate(period: period)
    }
    
    // Update
    func checkPeriodForUpdate() {
        if period.interval != UDManager.shared.period.interval {
            period = UDManager.shared.period
            delegate?.displayDidUpdate(period: period)
        }
    }
}
