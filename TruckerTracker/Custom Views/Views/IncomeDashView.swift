//
//  IncomeDashView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/15/24.
//

import UIKit

class IncomeDashView: UIView {
    
    var isTeam: Bool = false {
        didSet { layoutViewForDriverType() }
    }
    
    var amount: Int = 0 {
        didSet { updateAmountDisplay() }
    }
    
    var currency: String = Currency.usd.symbol {
        didSet { if oldValue != currency { updateAmountDisplay() } }
    }
    
    
    // Solo Driver
    lazy private var soloAmountLabel: UILabel = {
        return createLabel(size: 24, weight: .bold)
    }()
    
    
    // Team Driver
    // per Team
    lazy private var teamAmountLabel: UILabel = {
        return createLabel(size: 21, weight: .bold)
    }()
    
    lazy private var perTeamLabel = {
        return createLabel(text: "per team", size: 14, weight: .medium)
    }()
    
    // saparator
    lazy private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.textColor
        return view
    }()
    
    // per Driver
    lazy private var driverAmountLabel = {
        return createLabel(size: 21, weight: .bold)
    }()
    
    lazy private var perDriverLabel = {
        return createLabel(text: "per driver", size: 14, weight: .medium)
    }()
    
    
    
    // Update amount
    private func updateAmountDisplay() {
        if isTeam {
            teamAmountLabel.text = currency + " " + amount.formattedWithSeparator()
            driverAmountLabel.text = currency + " " + (amount/2).formattedWithSeparator()
        } else {
            soloAmountLabel.text = currency + " " + amount.formattedWithSeparator()
        }
    }
    
    // UI creators
    private func createLabel(text: String? = "", size: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = AppColors.textColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        
        return label
    }
    
    // Layout
    private func layoutViewForDriverType() {
        subviews.forEach { $0.removeFromSuperview() }
        if isTeam { layoutUIForTeamDriver() } else { layoutUIForSoloDriver() }
    }
    
    private func layoutUIForSoloDriver() {
        addSubview(soloAmountLabel)
        soloAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            soloAmountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            soloAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            soloAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5)
        ])
    }
    
    private func layoutUIForTeamDriver() {
        [teamAmountLabel, perTeamLabel, separatorView, driverAmountLabel, perDriverLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            separatorView.widthAnchor.constraint(equalToConstant: 2),
            separatorView.heightAnchor.constraint(equalToConstant: 15),
            separatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            teamAmountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 75),
            teamAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12),
            teamAmountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 5),
            teamAmountLabel.trailingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: -15),
            
            perTeamLabel.topAnchor.constraint(equalTo: teamAmountLabel.bottomAnchor, constant: 3),
            perTeamLabel.centerXAnchor.constraint(equalTo: teamAmountLabel.centerXAnchor, constant: 5),
            
            driverAmountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 75),
            driverAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12),
            driverAmountLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 15),
            driverAmountLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -5),
            
            perDriverLabel.topAnchor.constraint(equalTo: driverAmountLabel.bottomAnchor, constant: 3),
            perDriverLabel.centerXAnchor.constraint(equalTo: driverAmountLabel.centerXAnchor, constant: 5)
        ])
    }
}
