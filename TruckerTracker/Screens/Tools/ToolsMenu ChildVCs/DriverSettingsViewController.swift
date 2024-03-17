//
//  DriverSettingsViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/3/23.
//

import UIKit

class DriverSettingsViewController: UIViewController {
    
    let padding: CGFloat = 15
    private let tableView = UITableView()
    private let saveButton = ActionButton()
    private var savingOverlayView: UIView?
    private lazy var spinner: UIActivityIndicatorView = createSpinner()
    
    let viewModel = DriverSettingsViewModel()
    
    var settingsHaveChanges: Bool = false {
        didSet { updateSaveButtonState() }
    }

    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        configureTableView()
        configureSaveButton()
        settingsHaveChanges = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("test")
    }
    
    // UI
    private func layoutUI() {
        view.addSubviews(tableView, saveButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomMultiplier: CGFloat = DeviceTypes.isiPhoneSE ? 1 : 2
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 45),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                           constant: bottomMultiplier * -padding),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 2*padding),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    // TableView
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.register(DriverNameCell.nib, forCellReuseIdentifier: DriverNameCell.identifier)
        tableView.register(DriverTypeCell.nib, forCellReuseIdentifier: DriverTypeCell.identifier)
        tableView.register(DriverPayRateCell.nib, forCellReuseIdentifier: DriverPayRateCell.identifier)
    }
    
    // Save button
    private func configureSaveButton() {
        saveButton.set(title: "SAVE", action: .confirm, shape: .capsule)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func updateSaveButtonState() {
        UIView.animate(withDuration: 0.25) {
            self.saveButton.isEnabled = self.settingsHaveChanges
            self.saveButton.alpha = self.settingsHaveChanges ? 1 : 0.75
        }
    }
    
    // Spinner
    private func createSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = .systemGreen
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: parent?.view.centerXAnchor ?? view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: parent?.view.centerYAnchor ?? view.centerYAnchor)
        ])
        
        return spinner
    }
    
    // Checkmark
    private func showCheckmark() {
        let checkmarkView = createCheckmark()
        checkmarkView.showCheckmark()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + checkmarkView.animationDuration*2) {
            checkmarkView.removeFromSuperview()
        }
    }
    
    private func createCheckmark() -> CheckmarkView {
        let squareSize: CGFloat = 40
        let checkmark = CheckmarkView(frame: CGRect(x: 0, y: 0, width: squareSize,
                                                            height: squareSize))
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkmark)

        let centerYAnchor = parent?.view.centerYAnchor ?? view.centerYAnchor
        let centerXAnchor = parent?.view.centerXAnchor ?? view.centerXAnchor
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -squareSize/2),
            checkmark.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -squareSize/2)
        ])
        
        return checkmark
    }
    
    // Saving overlay
    func showSavingOverlay() {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.pinToEdges(of: view)
        self.savingOverlayView = overlayView
    }
    
    func dismissSavingOverlay() {
        self.savingOverlayView?.removeFromSuperview()
        self.savingOverlayView = nil
    }
    
    // Save functionality
    @objc private func saveButtonTapped() {
        spinner.startAnimating()
        showSavingOverlay()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.settingsHaveChanges = false
            self?.spinner.stopAnimating()
            self?.dismissSavingOverlay()
            self?.showCheckmark()
        }
    }
}


// MARK: - UITableView Delegate
extension DriverSettingsViewController: UITableViewDelegate {
    // Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = 15
        let settingVM = viewModel.settings[indexPath.row]
        
        switch settingVM.type {
        case .name:       return 60 + spacing
        case .driverType:  return 125 + spacing
        case .payRate:     return 110 + spacing
        }
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSettingVM = viewModel.settings[indexPath.row]
        
        if selectedSettingVM.type == .name,
            let driverNameCell = tableView.cellForRow(at: indexPath) as? DriverNameCell {
            driverNameCell.activateTextField()
        }
    }
}

// MARK: - UITableView DataSource
extension DriverSettingsViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settings.count
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingVM = viewModel.settings[indexPath.row]
        
        switch settingVM.type {
        case .name:
            guard let driverNameVM = settingVM as? DriverNameSettingVM else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverNameCell.identifier) as! DriverNameCell
            cell.configure(image: driverNameVM.image,
                           title: driverNameVM.title,
                           input: driverNameVM.name)
            
            cell.inputDidChange = { [weak self] name in
                self?.settingsHaveChanges = true
                self?.viewModel.updateName(with: name)
            }
            
            return cell
            
        case .driverType:
            guard let driverTypeVM = settingVM as? DriverTypeSettingVM else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverTypeCell.identifier) as! DriverTypeCell
            cell.configure(title: driverTypeVM.title,
                           image: driverTypeVM.image,
                           isTeamDriver: driverTypeVM.isTeamDriver)
            
            cell.teamTypeSelected = { [weak self] isTeamDriver in
                self?.settingsHaveChanges = true
                self?.viewModel.updateTeamStatus(with: isTeamDriver)
            }
            
            return cell
            
        case .payRate:
            guard let driverPayRateVM = settingVM as? DriverPayRateSettingVM else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverPayRateCell.identifier) as! DriverPayRateCell
            cell.configure(title: driverPayRateVM.title,
                           image: driverPayRateVM.image,
                           payRate: driverPayRateVM.payRate)
            
            cell.payRateChanged = { [weak self] payRate in
                self?.settingsHaveChanges = true
                self?.viewModel.updatePayRate(with: payRate)
            }
            
            return cell
        }
    }
}
