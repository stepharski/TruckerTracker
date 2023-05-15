//
//  AppSettingsViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/14/23.
//

import UIKit

class AppSettingsViewController: UIViewController {
    
    let padding: CGFloat = 15
    let tableView = UITableView()
    
    let viewModel = AppSettingsViewModel()
    var pickerTriggeredRow: Int?

    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
        configureNavBar()
        configureTableView()
    }

    // UI
    private func layoutUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 2*padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }

    // Configuration
    private func configureNavBar() {
        guard let parentVC = parent else { return }
        parentVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: SFSymbols.gearArrows,
            style: .plain,
            target: self,
            action: #selector(resetButtonTapped))
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.register(SettingOptionPickerCell.nib, forCellReuseIdentifier: SettingOptionPickerCell.identifier)
    }

    // Navigation
    func showPickerVC(items: [String], selectedIndex: Int) {
        let pickerVC = OptionPickerViewController(pickerItems: items,
                                                  selectedRow: selectedIndex)
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .pageSheet
        pickerVC.sheetPresentationController?.detents = [.medium()]
        
        present(pickerVC, animated: true)
    }
    
    // Reset
    @objc func resetButtonTapped() {
        showAlert()
    }
    
    func showAlert() {
        let alertVC = AlertViewController(title: "Reset Settings",
                      message: "This will reset your app settings to their default values. Are you sure?",
                      actionTitle: "Reset", actionType: .destruct, cancelTitle: "Cancel")

        alertVC.didTapAction = { [unowned self] in
            self.viewModel.resetAllSettings()
            self.tableView.reloadData()
        }
        
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
}

// MARK: - OptionPicker Delegate
extension AppSettingsViewController: OptionPickerDelegate {
    func didSelectRow(_ row: Int) {
        guard let tableViewRow = pickerTriggeredRow,
              let settingVM = viewModel.settings[safe: tableViewRow] else { return }
        
        viewModel.updateSettings(settingVM, valueIndex: row)
        tableView.reloadRows(at: [IndexPath(row: tableViewRow, section: 0)], with: .none)
    }
}

// MARK: - UITableView Delegate
extension AppSettingsViewController: UITableViewDelegate {
    // Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 + 15
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingVM = viewModel.settings[indexPath.row]
        guard let allTypes = settingVM.allTypes, let valueIndex = settingVM.valueIndex else { return }
        
        pickerTriggeredRow = indexPath.row
        showPickerVC(items: allTypes, selectedIndex: valueIndex)
    }
}

// MARK: - UITableView DataSource
extension AppSettingsViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settings.count
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingVM = viewModel.settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingOptionPickerCell.identifier)
                                                                    as! SettingOptionPickerCell
        cell.configure(image: settingVM.image,
                       title: settingVM.title,
                       value: settingVM.stringValue)
        return cell
    }
}
