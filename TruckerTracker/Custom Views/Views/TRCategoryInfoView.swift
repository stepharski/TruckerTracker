//
//  TRCategoryInfoView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 9/7/22.
//

import UIKit

class TRCategoryInfoView: UIView {

    let generalStackView = UIStackView()
    let labelsStackView = UIStackView()
    
    let symbolImageView = UIImageView()
    let countLabel = UILabel()
    let titleLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureGeneralStackView()
        configureLabelsStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(categoryType: TrackerCategoryType, withCount count: Int) {
        self.init(frame: .zero)
        
        symbolImageView.image = categoryType.image
        symbolImageView.tintColor = categoryType.imageTintColor
        countLabel.text = String(count)
        titleLabel.text = categoryType.title
    }

    
    func configureGeneralStackView() {
        generalStackView.axis = .vertical
        generalStackView.alignment = .center
        generalStackView.distribution = .fill
        generalStackView.spacing = DeviceTypes.isiPhoneZoomed ? 10 : 20
        
        generalStackView.addArrangedSubview(symbolImageView)
        generalStackView.addArrangedSubview(labelsStackView)
    }
    
    func configureLabelsStackView() {
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .center
        labelsStackView.distribution = .fill
        labelsStackView.spacing = 0
        
        labelsStackView.addArrangedSubview(countLabel)
        labelsStackView.addArrangedSubview(titleLabel)
    }
    
    func configureUI() {
        addSubview(generalStackView)
        generalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        symbolImageView.contentMode = .scaleAspectFit
        
        let countLabelFontSize: CGFloat = DeviceTypes.isiPhoneZoomed ? 20 : 28
        countLabel.font = UIFont.systemFont(ofSize: countLabelFontSize, weight: .bold)
        countLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        
        let titleLabelFontSize: CGFloat = DeviceTypes.isiPhoneZoomed ? 14 : 16
        titleLabel.font = UIFont.systemFont(ofSize: titleLabelFontSize, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 0.8)
        
        
        let symbolImageHeight: CGFloat = DeviceTypes.isiPhoneZoomed ? 30 : 40
        
        NSLayoutConstraint.activate([
            generalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            generalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            symbolImageView.heightAnchor.constraint(equalToConstant: symbolImageHeight),
            symbolImageView.widthAnchor.constraint(equalToConstant: symbolImageHeight)
        ])
    }
}
