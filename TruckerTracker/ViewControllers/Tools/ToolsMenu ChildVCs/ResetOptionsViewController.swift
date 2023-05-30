//
//  ResetOptionsViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/26/23.
//

import UIKit

// MARK: - Reset Options
private enum ResetOptions: String, CaseIterable {
    case eraseHistory
    case resetApp
    
    var title: String {
        return self.rawValue.camelCaseToWords()
    }
    
    var description: String {
        switch self {
        case .eraseHistory:
            return "Remove all my added data \nbut keep driver and app configuration"
        case .resetApp:
            return "Delete driver profile, all associated data \nand reset app configuration"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .eraseHistory:
            return "This will remove all your added data."
        case .resetApp:
            return "This will delete your profile and all associated data."
        }
    }
}

// MARK: - ResetOptions View Controller
class ResetOptionsViewController: UIViewController {
    
    private let tableContainer = UIView()
    private let tableView = UITableView()
    private let resetButton = ActionButton()
    
    private let options = ResetOptions.allCases
    private var selectedOption: ResetOptions = .eraseHistory

    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        configureTableView()
        configureResetButton()
    }

    // Layout
    private func layoutUI() {
        [tableView, resetButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let bottomMultiplier: CGFloat = DeviceTypes.isiPhoneSE ? 1 : 2
        NSLayoutConstraint.activate([
            resetButton.heightAnchor.constraint(equalToConstant: 45),
            resetButton.widthAnchor.constraint(equalToConstant: 200),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15*bottomMultiplier),
            
            tableView.heightAnchor.constraint(equalToConstant: 250),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    // Configuration
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        
        tableView.roundEdges(by: 15)
        tableView.dropShadow(opacity: 0.1)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray6

        tableView.register(ResetOptionCell.nib, forCellReuseIdentifier: ResetOptionCell.identifier)
        tableView.register(SectionTitleHeaderView.self, forHeaderFooterViewReuseIdentifier:
                                                    SectionTitleHeaderView.identifier)
    }
    
    private func configureResetButton() {
        resetButton.set(title: "RESET", action: .destruct, shape: .capsule)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    // Reset
    @objc private func resetButtonTapped() {
        showAlert()
    }
    
    func showAlert() {
        let alertVC = AlertViewController(title: selectedOption.title,
                      message: "\(selectedOption.alertMessage) Are you sure?",
                      actionTitle: "Reset", actionType: .destruct, cancelTitle: "Cancel")

        alertVC.didTapAction = {
            //TODO: Handle selected option
        }
        
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
}

// MARK: - UITableView DataSource
extension ResetOptionsViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResetOptionCell.identifier)
                                                                        as! ResetOptionCell
        let option = options[indexPath.row]
        cell.optionTitle = option.title
        cell.optionDescription = option.description
        cell.optionIsSelected = selectedOption == option
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension ResetOptionsViewController: UITableViewDelegate {
    // Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // Header View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                SectionTitleHeaderView.identifier) as! SectionTitleHeaderView
        headerView.labelCenterYPadding = -8
        headerView.labelXPadding = 20
        headerView.titleColor = .dark
        headerView.titleSize = .large
        headerView.title = "Options"
        
        return headerView
    }
    
    // Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = options[indexPath.row]
        tableView.reloadData()
    }
}
