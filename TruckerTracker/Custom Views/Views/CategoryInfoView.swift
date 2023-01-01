//
//  CategoryInfoView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/24/22.
//

import UIKit

class CategoryInfoView: UIView {

    let symbolImageView = UIImageView()
    let countLabel = UILabel()
    let titleLabel = UILabel()


    override init(frame: CGRect) {
        super.init(frame: frame)

        configureCountLabel()
        configureTitleLabel()
        configureSymbolImageView()
        translatesAutoresizingMaskIntoConstraints = false
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


    private func configureCountLabel() {
        self.addSubview(countLabel)

        countLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        countLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        let centerYPadding: CGFloat = DeviceTypes.isiPhoneSE ? 10 : 20
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: centerYPadding),
            countLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 5),
            countLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: -5),
        ])
    }

    private func configureTitleLabel() {
        self.addSubview(titleLabel)

        titleLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 0.8)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor)
        ])
    }

    private func configureSymbolImageView() {
        self.addSubview(symbolImageView)
        
        let imageHeight: CGFloat = 45
        let imageBottomConstraint: CGFloat = DeviceTypes.isiPhoneSE ? 10 : 20
        
        symbolImageView.contentMode = .scaleAspectFit
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            symbolImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: imageHeight),
            symbolImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            symbolImageView.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: -imageBottomConstraint)
        ])
    }
}
