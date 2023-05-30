//
//  ToolMenuViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/14/23.
//

import UIKit

class ToolMenuViewController: UIViewController {

    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var toolImageView: UIImageView!
    @IBOutlet private var toolDescription: UILabel!
    @IBOutlet private var toolContainerView: UIView!
    
    var selectedTool: ToolsType = .settings
    lazy var toolChildVC = { getToolChildVC() }()
    
    // Life cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        updateHeaderHeight()
        addToolChildVC()
        dismissKeyboardOnTouchOutside()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureHeader()
    }
    
    // Configuration
    private func configureNavBar() {
        navigationItem.title = selectedTool.title
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
        
        toolImageView.image = selectedTool.image
        toolDescription.text = selectedTool.description
    }
    
    func updateHeaderHeight() {
        headerHeightConstraint.constant = DeviceTypes.isiPhoneSE ? 225 : 265
    }
    
    // Child VC
    func getToolChildVC() -> UIViewController {
        switch selectedTool {
        case .settings:
            return AppSettingsViewController()
        case .driver:
            return DriverSettingsViewController()
        case .attachments:
            return AttachmentsListViewController()
        case .recurring:
            return RecurringExpensesListViewController()
        case .reset:
            return ResetOptionsViewController()
        case .feedback:
            return UIViewController()
        }
    }
    
    func addToolChildVC() {
        addChild(toolChildVC)
        toolContainerView.addSubview(toolChildVC.view)
        toolChildVC.view.frame = toolContainerView.bounds
        toolChildVC.didMove(toParent: self)
    }
    
    // Navigation
    func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonTapped() {
        if let driverSettingsVC = toolChildVC as? DriverSettingsViewController,
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
