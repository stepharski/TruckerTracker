//
//  PageProgressView.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/17/24.
//

import UIKit

class PageProgressView: UIView {
    // MARK: Variables
    var currentPage = 0 {
        didSet { updateUI() }
    }

    private var numberOfPages = 3
    private var pageViews: [UIView] = []
    private var progressColor = UIColor.paleMint

    // MARK: Life cycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }

    // MARK: UI handling
    private func setupUI() {
        backgroundColor = .clear
        (0..<numberOfPages).forEach { _ in
            let pageView = UIView()
            pageView.clipsToBounds = true
            pageView.backgroundColor = .paleMint
            pageView.layer.cornerRadius = bounds.height / 2
            addSubviews(pageView)
            pageViews.append(pageView)
        }
    }

    private func updateUI() {
        guard currentPage < pageViews.count else { return }
        for (index, view) in pageViews.enumerated() {
            let spacing = bounds.width * 0.1 / 2
            let regularWidth = bounds.width * 0.2
            let selectedWidth = bounds.width * 0.5
            var xPosition = (regularWidth + spacing) * CGFloat(index)
            if currentPage < index { xPosition += bounds.width * 0.3 }
            UIView.animate(withDuration: 0.2) {
                view.frame = CGRect(
                    x: xPosition,
                    y: 0,
                    width: self.currentPage == index ? selectedWidth : regularWidth,
                    height: self.bounds.height)
            }
        }
    }
}
