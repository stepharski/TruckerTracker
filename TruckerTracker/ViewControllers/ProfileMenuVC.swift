//
//  ProfileMenuVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/4/22.
//

import UIKit

class ProfileMenuVC: UIViewController {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuDescriptionLabel: UILabel!
    @IBOutlet weak var menuContainerView: UIView!
    
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
    
    
    // Navigation
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
