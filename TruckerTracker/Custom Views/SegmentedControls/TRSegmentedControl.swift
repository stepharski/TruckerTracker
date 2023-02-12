//
//  TRSegmentedControl.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/26/22.
//

import UIKit

// MARK: - TRSegmentedControlType
enum SegmentSelectorType {
    case underline, capsule
    
    var selectorColor: UIColor {
        switch self {
        case .underline:
            return AppColors.textColor
        case .capsule:
            return .systemGray6.withAlphaComponent(0.25)
        }
    }
    
    var padding: CGFloat {
        switch self {
        case .underline:
            return 0
        case .capsule:
            return 10
        }
    }
}


// MARK: - TRSegmentedControl
class TRSegmentedControl: UIControl {
    
    var titles = [String]()
    var subtitles = [String]()
    
    var selectorType: SegmentSelectorType = .underline

    var selectedIndex: Int = 0 {
        didSet { moveSelector(to: selectedIndex)} }
    
    var textColor: UIColor = AppColors.textColor.withAlphaComponent(0.75)
    var selectedTextColor: UIColor = AppColors.textColor
    
    private var buttons = [UIButton]()
    private var selectorView = UIView()
    
    
    // Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Configure
    func configure(with titles: [String], subtitles: [String], type: SegmentSelectorType) {
        self.titles = titles
        self.subtitles = subtitles
        self.selectorType = type
        
        setupButtons()
    }
    
    // Buttons
    private func setupButtons() {
        guard titles.count > 0 else { return }
        
        subviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        
        for (index, title) in titles.enumerated() {
            
            var config = UIButton.Configuration.plain()
            config.baseBackgroundColor = .clear
            config.titleAlignment = .center
            
            var attTitle = AttributedString(title)
            attTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            attTitle.foregroundColor = textColor
            config.attributedTitle = attTitle
            
            if subtitles.indices.contains(index) {
                var attsubtitle = AttributedString(subtitles[index])
                attsubtitle.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                attsubtitle.foregroundColor = textColor
                config.attributedSubtitle = attsubtitle
            }
            
            let handler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .selected:
                    button.configuration?.attributedTitle?.foregroundColor = self.selectedTextColor
                    button.configuration?.attributedSubtitle?.foregroundColor = self.selectedTextColor
                default:
                    button.configuration?.attributedTitle?.foregroundColor = self.textColor
                    button.configuration?.attributedSubtitle?.foregroundColor = self.textColor
                }
            }
            
            let button = UIButton(configuration: config)
            button.configurationUpdateHandler = handler
            button.isSelected = index == selectedIndex
            button.addTarget(self, action: #selector(buttonTapped(sender:)),
                                                         for: .touchUpInside)
            addSubview(button)
            button.tag = index
            buttons.append(button)
        }
        
        setupButtonsStack()
        setupSelector()
    }
    
    @objc func buttonTapped(sender: UIButton) {
        for (index, button) in buttons.enumerated() {
            button.isSelected = button == sender
            if button.isSelected {
                selectedIndex = index
                moveSelector(to: index)
                sendActions(for: .valueChanged)
            }
        }
    }
    
    private func setupButtonsStack() {
        let stack = UIStackView(arrangedSubviews: buttons)
        
        stack.spacing = 0
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.pinToEdges(of: self)
    }
    
    // Selector
    private func setupSelector() {
        selectorView.removeFromSuperview()

        addSubview(selectorView)
        selectorView.backgroundColor = selectorType.selectorColor
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        
        let selectorWidth = frame.width / CGFloat(titles.count)

        switch selectorType {
        case .underline:
            let selectorHeight: CGFloat = 2
            NSLayoutConstraint.activate([
                selectorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                selectorView.widthAnchor.constraint(equalToConstant: selectorWidth),
                selectorView.heightAnchor.constraint(equalToConstant: selectorHeight),
                selectorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])

        case .capsule:
            let padding: CGFloat = selectorType.padding
            NSLayoutConstraint.activate([
                selectorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
                selectorView.widthAnchor.constraint(equalToConstant: selectorWidth - (2 * padding)),
                selectorView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
                selectorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
            ])

            selectorView.roundEdges(by: 25)
        }
    }
    
    private func moveSelector(to index: Int) {
        UIView.animate(withDuration: 0.3) {
            self.selectorView.frame.origin.x = self.frame.width
                                                / CGFloat(self.titles.count)
                                                * CGFloat(index)
                                                + self.selectorType.padding
        }
    }
}
