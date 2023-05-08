//
//  DriverSettingsViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/3/23.
//

import UIKit

class DriverSettingsViewController: UIViewController {
    
    let padding: CGFloat = 15
    let tableView = UITableView()
    
    let viewModel = DriverSettingsViewModel()

    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
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
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.register(SettingInputCell.nib, forCellReuseIdentifier: SettingInputCell.identifier)
        tableView.register(DriverTypeCell.nib, forCellReuseIdentifier: DriverTypeCell.identifier)
        tableView.register(DriverPayRateCell.nib, forCellReuseIdentifier: DriverPayRateCell.identifier)
    }
}


// MARK: - UITableView Delegate
extension DriverSettingsViewController: UITableViewDelegate {
    // Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = 15
        let option = viewModel.options[indexPath.row]
        
        switch option.type {
        case .name:       return 60 + spacing
        case .driverType:  return 125 + spacing
        case .payRate:     return 110 + spacing
        }
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = viewModel.options[indexPath.row]
        
        if selectedOption.type == .name,
            let driverNameCell = tableView.cellForRow(at: indexPath) as? SettingInputCell {
            driverNameCell.activateTextField()
        }
    }
}

// MARK: - UITableView DataSource
extension DriverSettingsViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = viewModel.options[indexPath.row]
        
        switch option.type {
        case .name:
            guard let nameOption = option as? DriverSettingsNameOption else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingInputCell.identifier) as! SettingInputCell
            cell.configure(image: nameOption.image, title: nameOption.title, input: nameOption.name)
            
            cell.inputDidChange = { [weak self] name in
                self?.viewModel.updateName(with: name)
            }
            
            return cell
            
        case .driverType:
            guard let typeOption = option as? DriverSettingsTypeOption else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverTypeCell.identifier) as! DriverTypeCell
            cell.configure(title: typeOption.title, image: typeOption.image,
                                               isTeamDriver: typeOption.isTeamDriver)
            
            cell.teamTypeSelected = { [weak self] isTeamDriver in
                self?.viewModel.updateTeamStatus(with: isTeamDriver)
            }
            
            return cell
            
        case .payRate:
            guard let payRateOption = option as? DriverSettingsPayRateOption else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverPayRateCell.identifier) as! DriverPayRateCell
            cell.configure(title: payRateOption.title,
                           image: payRateOption.image,
                           payRate: payRateOption.payRate)
            return cell
        }

    }
}
