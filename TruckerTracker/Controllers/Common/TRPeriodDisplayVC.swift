//
//  TRPeriodDisplayVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/2/23.
//

import UIKit

// MARK: - TRPeriodDisplayVCDelegate
protocol TRPeriodDisplayVCDelegate: AnyObject {
    func didTapPeriodDisplay()
    func displayDidUpdate(period: Period)
}

// MARK: - TRPeriodDisplayVC
class TRPeriodDisplayVC: UIViewController {
    
    weak var delegate: TRPeriodDisplayVCDelegate?

    private let nextButton = UIButton()
    private let previousButton = UIButton()
    
    private let periodlabel = UILabel()
    private let numberOfItemsLabel = UILabel()
    
    lazy var period: Period = {
        return UDManager.shared.getPeriod()
    }() {
        didSet {
            updatePeriodLabel()
        }
    }
    
    var numberOfItems: Int = 5 {
        didSet {
            updateNumberOfItemsLabel()
        }
    }
    
    var itemName: String = "Document" {
        didSet {
            updateNumberOfItemsLabel()
        }
    }
    
    
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
            $0.textColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
            $0.textAlignment = .center
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        periodlabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        numberOfItemsLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
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
            $0.imageView?.tintColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
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
        UDManager.shared.savePeriod(period)
        delegate?.displayDidUpdate(period: period)
    }
    
    @objc private func previousButtonTapped() {
        period.interval = period.interval.previousInterval()
        UDManager.shared.savePeriod(period)
        delegate?.displayDidUpdate(period: period)
    }
    
    // Update
    func checkPeriodForUpdate() {
        if period.interval != UDManager.shared.getPeriod().interval {
            period = UDManager.shared.getPeriod()
            delegate?.displayDidUpdate(period: period)
        }
    }
}
