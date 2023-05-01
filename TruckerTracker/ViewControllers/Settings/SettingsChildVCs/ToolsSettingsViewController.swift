//
//  ToolsSettingsViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/24/23.
//

import UIKit

class ToolsSettingsViewController: UIViewController {
    
    let padding: CGFloat = 15
    let tableView = UITableView()
    
    let viewModel = ToolsSettingsViewModel()
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
        tableView.register(SettingToggleCell.nib, forCellReuseIdentifier: SettingToggleCell.identifier)
    }

    // Navigation
    func showPickerVC(items: [String], selectedIndex: Int) {
        let pickerVC = TRPickerVC(pickerItems: items, selectedRow: selectedIndex)
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .pageSheet
        pickerVC.sheetPresentationController?.detents = [.medium()]
        
        present(pickerVC, animated: true)
    }
    
    // Reset
    @objc func resetButtonTapped() {
        //TODO: Reset Settings
    }
}

// MARK: - TRPickerDelegate
extension ToolsSettingsViewController: TRPickerDelegate {
    func didSelectRow(_ row: Int) {
        guard let tableViewRow = pickerTriggeredRow,
              let option = viewModel.options[safe: tableViewRow] else { return }
        
        viewModel.updateOption(option, valueIndex: row)
        tableView.reloadRows(at: [IndexPath(row: tableViewRow, section: 0)], with: .none)
    }
}

// MARK: - UITableViewDelegate
extension ToolsSettingsViewController: UITableViewDelegate {
    // Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 + 15
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        
        switch option.type {
        case .distance, .currency, .weekStartDay:
            guard let allTypes = option.allTypes,
                    let valueIndex = option.valueIndex else { return }
            
            pickerTriggeredRow = indexPath.row
            showPickerVC(items: allTypes, selectedIndex: valueIndex)
            
        case .darkMode:
            return
        }
    }
}

// MARK: - UITableViewDataSource
extension ToolsSettingsViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = viewModel.options[indexPath.row]
        
        switch option.type {
        case .distance, .currency, .weekStartDay:
            let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        SettingOptionPickerCell.identifier)
                                                                as! SettingOptionPickerCell
            cell.configure(image: option.image, title: option.title, value: option.stringValue)
            return cell
            
        case .darkMode:
            guard let darkModeOption = option as? ToolsViewModelDarkModeOption else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingToggleCell.identifier)
                                                                    as! SettingToggleCell
            cell.configure(image: darkModeOption.image,
                           title: darkModeOption.title,
                           isToggleOn: darkModeOption.isDarkModeOn)
            return cell
        }
    }
}
