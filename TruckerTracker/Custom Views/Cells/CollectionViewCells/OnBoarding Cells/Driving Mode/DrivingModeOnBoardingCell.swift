//
//  DrivingModeOnBoardingCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/27/24.
//

import UIKit

class DrivingModeOnBoardingCell: UICollectionViewCell {
    // MARK: @IBOutlet
    @IBOutlet private var soloView: UIView!
    @IBOutlet private var teamView: UIView!
    @IBOutlet private var soloLabel: UILabel!
    @IBOutlet private var teamLabel: UILabel!

    // MARK: Variables
    var didSelectTeamMode: ((Bool) -> Void)?

    private var isTeam: Bool = false {
        didSet { updateUI() }
    }

    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        updateUI()
        bindGestures()
    }

    // MARK: UI Setup
    private func setupUI() {
        backgroundColor = .clear
        [soloView, teamView].forEach { button in
            guard let button else { return }
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.paleMint.cgColor
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }

    private func updateUI() {
        soloLabel.textColor = isTeam ? .paleMint : .black
        teamLabel.textColor = isTeam ? .black : .paleMint
        soloView.backgroundColor = isTeam ? .clear : .paleMint
        teamView.backgroundColor = isTeam ? .paleMint : .clear
    }

    // MARK: Gestures
    private func bindGestures() {
        let tapGestureSolo = UITapGestureRecognizer(target: self, action: #selector(changeMode(_:)))
        let tapGestureTeam = UITapGestureRecognizer(target: self, action: #selector(changeMode(_:)))
        soloView.addGestureRecognizer(tapGestureSolo)
        teamView.addGestureRecognizer(tapGestureTeam)
    }

    @objc private func changeMode(_ sender: UITapGestureRecognizer) {
        isTeam = sender.view == teamView
        didSelectTeamMode?(isTeam)
    }
}
