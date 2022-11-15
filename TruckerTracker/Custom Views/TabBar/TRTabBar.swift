//
//  TRTabBar.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/26/22.
//

import UIKit

enum TRTabBarItem: String {
    case tracker, newItem, profile

    var image: UIImage? {
        switch self {
        case .tracker:
            return SFSymbols.circleLine
        case .newItem:
            return nil
        case .profile:
            return SFSymbols.person
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .tracker:
            return SFSymbols.circleLineFill
        case .newItem:
            return nil
        case .profile:
            return SFSymbols.personFill
        }
    }
    
    var title: String {
        return self.rawValue.capitalized(with: nil)
    }
}


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
        newItemButton.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
        newItemButton.tintColor = .black
        newItemButton.roundEdges(by: 23)
        
        newItemButton.addTarget(self, action: #selector(self.addItemButtonAction), for: .touchUpInside)
        self.addSubview(newItemButton)
    }
    
    func addShadowToButtons() {
        self.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }
    
    @objc func addItemButtonAction() {
        didTapNewItemButton?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        return self.newItemButton.frame.contains(point) ? self.newItemButton : super.hitTest(point, with: event)
    }
}
