//
//  DriverPayRateCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/21/22.
//

import UIKit

class DriverPayRateCell: UITableViewCell {

    @IBOutlet private var slider: TRSlider!
    @IBOutlet private var percentLabel: UILabel!
    
    var minPayRate: Float = 0
    var maxPayRate: Float = 100
    
    var payRate: Float = 88 {
        willSet {
            if payRate < minPayRate {
                self.payRate = minPayRate
            } else if payRate > maxPayRate {
                self.payRate = maxPayRate
            }
        }
        didSet {
            slider.value = payRate
            percentLabel.text = "\(Int(payRate))%"
        }
    }
    
    var payRateChanged: ((_ payRate: Float) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureSlider()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    
    @IBAction func sliderChanged(_ sender: TRSlider) {
        payRate = sender.value
        payRateChanged?(payRate)
    }
    
    
    func configureSlider() {
        slider.value = payRate
        slider.minimumValue = minPayRate
        slider.maximumValue = maxPayRate
    }
}
