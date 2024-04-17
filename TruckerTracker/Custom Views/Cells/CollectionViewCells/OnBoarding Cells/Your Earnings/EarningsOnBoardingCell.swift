//
//  EarningsOnBoardingCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/27/24.
//

import UIKit

class EarningsOnBoardingCell: UICollectionViewCell {
    // MARK: - @IBOutlet
    @IBOutlet private var percentLabel: UILabel!
    @IBOutlet private var slider: TRSlider!

    // MARK: Variables
    var didChangeEarningsPercent: ((Int) -> Void)?
    var earningsPercent = 88 {
        didSet {
            slider.value = Float(earningsPercent) / 100
            percentLabel.text = "\(earningsPercent)%"
        }
    }

    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    // MARK: - @IBAction
    @IBAction private func sliderValueChanged(_ sender: TRSlider) {
        percentLabel.text = "\(Int(sender.value * 100))%"
        didChangeEarningsPercent?(Int(sender.value * 100))
    }
}
