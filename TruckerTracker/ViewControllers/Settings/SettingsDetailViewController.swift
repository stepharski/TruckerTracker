//
//  SettingsDetailViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/24/23.
//

import UIKit

class SettingsDetailViewController: UIViewController {

    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var settingImageView: UIImageView!
    @IBOutlet private var settingDescription: UILabel!
    @IBOutlet private var settingContainerView: UIView!
    
    var setting: SettingsType = .tools
    
    
    // Life cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        updateHeaderHeight()
        addSettingChildVC()
        dismissKeyboardOnTouchOutside()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureHeader()
    }
    
    // Configuration
    private func configureNavBar() {
        navigationItem.title = setting.title
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbols.arrowBack,
            style: .plain,
            target: self,
            action: #selector(popVC))
    }
    
    private func configureHeader() {
        headerView.dropShadow(opacity: 0.3)
        headerView.applyGradient(colors: AppColors.headerColors, locations: [0, 1])
        
        settingImageView.image = setting.image
        settingDescription.text = setting.description
    }
    
    func updateHeaderHeight() {
        headerHeightConstraint.constant = DeviceTypes.isiPhoneSE ? 225 : 265
    }
    
    // Child VC
    func getSettingVC() -> UIViewController {
        switch setting {
        case .tools:
            return ToolsSettingsViewController()
        case .driver:
            return UIViewController()
        case .attachments:
            return UIViewController()
        case .recurring:
            return UIViewController()
        case .reset:
            return UIViewController()
        case .cloud:
            return UIViewController()
        }
    }
    
    func addSettingChildVC() {
        let settingVC = getSettingVC()
        addChild(settingVC)
        settingContainerView.addSubview(settingVC.view)
        settingVC.view.frame = settingContainerView.bounds
        settingVC.didMove(toParent: self)
    }
    
    // Navigation
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
