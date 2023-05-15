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
   
    private var minPayRate: Int = 1
    private var maxPayRate: Int = 100
    
    private var payRate: Int = 88 {
        willSet {
            if payRate < minPayRate {
                self.payRate = minPayRate
            } else if payRate > maxPayRate {
                self.payRate = maxPayRate
            }
        }
        didSet {
            slider.value = Float(payRate)
            percentLabel.text = "\(payRate)%"
        }
    }
    
    var payRateChanged: ((_ payRate: Int) -> ())?
    
    
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
        guard payRate != Int(sender.value) else { return }
        
        payRate = Int(sender.value)
        payRateChanged?(payRate)
    }
    
    // Configuration
    func configure(title: String?, image: UIImage?, payRate: Int) {
        guard payRate > 0 else { return }
        
        self.payRate = payRate
        titleLabel.text = title
        titleImageVIew.image = image
    }
    
    private func configureUI() {
        contentView.roundEdges(by: 20)
        contentView.backgroundColor = .systemGray6
    }
    
    private func configureSlider() {
        slider.value = Float(payRate)
        slider.minimumValue = Float(minPayRate)
        slider.maximumValue = Float(maxPayRate)
        
        slider.layer.cornerRadius = 25
    }
}
