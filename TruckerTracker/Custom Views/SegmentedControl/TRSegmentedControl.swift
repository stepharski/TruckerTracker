//
//  TRSegmentedControl.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/26/22.
//

import UIKit

protocol TRSegmentedControlDelegate: AnyObject {
    func didSelectItem(at index: Int)
}

// TRSegmentedControl
class TRSegmentedControl: UIView {
    
    private var buttons = [UIButton]()
    
    weak var delegate: TRSegmentedControlDelegate!
    
    // Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(buttonTitles: [String], selectedIndex: Int) {
        self.init(frame: .zero)
        
        self.createButtons(with: buttonTitles, selectedIndex: selectedIndex)
    }
    
    
    // Configuration
    func createButtons(with titles: [String], selectedIndex: Int) {
        buttons.removeAll()
        titles.forEach { title in
            var config = UIButton.Configuration.plain()
            config.baseBackgroundColor = #colorLiteral(red: 0.6000000834, green: 0.6000000834, blue: 0.6000000834, alpha: 1)
            config.cornerStyle = .capsule
            
            var attTitle = AttributedString(title)
            attTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            config.attributedTitle = attTitle
            
            let handler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .selected:
                    button.configuration?.baseForegroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
                default:
                    button.configuration?.baseForegroundColor = .white.withAlphaComponent(0.6)
                }
            }
            
            let button = UIButton(configuration: config)
            button.isSelected = titles[selectedIndex] == title
            button.configurationUpdateHandler = handler
            button.addTarget(self, action: #selector(didSelectButton(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        configureStackView()
    }
    
    @objc private func didSelectButton(sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        
        buttons.forEach { $0.isSelected = $0 == sender }
        delegate.didSelectItem(at: index)
    }
    
    private func configureStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.pinToEdges(of: self)
    }
}
