//
//  TRTabBar.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/26/22.
//

import UIKit

// MARK: - TRTabBarItem
enum TRTabBarItem: String {
    case dashboard, newItem, tools

    var image: UIImage? {
        switch self {
        case .dashboard:
            return SFSymbols.listRect
        case .newItem:
            return nil
        case .tools:
            return SFSymbols.wrenchScrew
        }
    }
    
    var title: String {
        return self.rawValue.capitalized(with: nil)
    }
}

// MARK: - TRTabBar
class TRTabBar: UITabBar {
    
    private var newItemButton = UIButton()
    public var didTapNewItemButton: (() -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureAddItemButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newItemButton.center = CGPoint(x: frame.width/2, y: 0)
    }
    
    
    func configureAddItemButton() {
        newItemButton.frame.size = CGSize(width: 55, height: 55)
        
        newItemButton.setImage(SFSymbols.plus, for: .normal)
        newItemButton.backgroundColor = .label
        newItemButton.tintColor = .systemGray6
        newItemButton.roundEdges(by: 27)
        
        newItemButton.addTarget(self, action: #selector(self.addItemButtonAction), for: .touchUpInside)
        self.addSubview(newItemButton)
    }
    
    @objc func addItemButtonAction() {
        didTapNewItemButton?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        return self.newItemButton.frame.contains(point) ? self.newItemButton : super.hitTest(point, with: event)
    }
}
