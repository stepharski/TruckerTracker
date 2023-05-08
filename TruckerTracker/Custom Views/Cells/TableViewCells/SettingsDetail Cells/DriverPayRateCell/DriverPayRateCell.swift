//
//  DriverPayRateCell.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/21/22.
//

import UIKit

class DriverPayRateCell: UITableViewCell {
    
    @IBOutlet private var titleImageVIew: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var percentLabel: UILabel!
    @IBOutlet private var slider: TRSlider!
   
    private var minPayRate: Float = 0
    private var maxPayRate: Float = 100
    
    private var payRate: Float = 88 {
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
    
    
    // Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
        configureSlider()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0,
                                                             bottom: 15, right: 0))
    }
    
    // @IBAction
    @IBAction private func sliderChanged(_ sender: TRSlider) {
        payRate = sender.value
        payRateChanged?(payRate)
    }
    
    // Configuration
    func configure(title: String?, image: UIImage?, payRate: Float) {
        self.payRate = payRate
        titleLabel.text = title
        titleImageVIew.image = image
    }
    
    private func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
    }
    
    private func configureSlider() {
        slider.value = payRate
        slider.minimumValue = minPayRate
        slider.maximumValue = maxPayRate
        
        slider.layer.cornerRadius = 25
    }
}
