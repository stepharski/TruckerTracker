//
//  MenuDetailedVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/16/22.
//

import UIKit

class MenuDetailedVC: UIViewController {

    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var menuDescriptionLabel: UILabel!
    @IBOutlet var menuContainerView: UIView!
    
    var menuType: ProfileMenuType!
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.menuType = .tools
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureHeader()
        configureMenuContainer()
        addMenuChildVC()
    }
    
    
    // UI Configuration
    func configureNavBar() {
        navigationItem.title = menuType.title
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbols.arrowBack,
            style: .plain,
            target: self,
            action: #selector(popVC))
    }
    
    func configureHeader() {
        menuImageView.image = menuType.image
        menuDescriptionLabel.text = menuType.description
    }
    
    func configureMenuContainer() {
        menuContainerView.layer.cornerRadius = 30
        menuContainerView.applyGradient(colors: [#colorLiteral(red: 0.03137254902, green: 0.03921568627, blue: 0.03529411765, alpha: 1), #colorLiteral(red: 0.07450980392, green: 0.2274509804, blue: 0.1960784314, alpha: 1)], locations: [0, 1])
    }
    
    
    func addMenuChildVC() {
        var childVC = UIViewController()
        
        switch menuType {
        case .tools:
            childVC = ToolsMenuVC()
        case .driver:
            childVC = DriverMenuVC()
        default:
            break
        }
        
        addChild(childVC)
        menuContainerView.addSubview(childVC.view)
        childVC.view.frame = menuContainerView.bounds
        childVC.didMove(toParent: self)
    }
    
    // Navigation
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
