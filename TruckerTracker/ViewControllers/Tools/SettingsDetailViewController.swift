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
    lazy var settingChildVC = { getSettingChildVC() }()
    
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
            action: #selector(backButtonTapped))
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
    func getSettingChildVC() -> UIViewController {
        switch setting {
        case .tools:
            return ToolsSettingsViewController()
        case .driver:
            return DriverSettingsViewController()
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
        addChild(settingChildVC)
        settingContainerView.addSubview(settingChildVC.view)
        settingChildVC.view.frame = settingContainerView.bounds
        settingChildVC.didMove(toParent: self)
    }
    
    // Navigation
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonTapped() {
        if let driverSettingsVC = settingChildVC as? DriverSettingsViewController,
            driverSettingsVC.settingsHaveChanges {
            showDriverSettingsAlert()
        } else {
            popVC()
        }
    }
    
    func showDriverSettingsAlert() {
        let alertVC = AlertViewController(title: "Unsaved Changes",
                      message: "Changes have not been saved. Exit anyway?",
                      actionTitle: "Exit", actionType: .confirm, cancelTitle: "Cancel")

        alertVC.didTapAction = { [unowned self] in
            self.popVC()
        }
        
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
}
