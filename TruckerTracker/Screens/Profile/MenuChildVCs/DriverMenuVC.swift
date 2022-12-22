//
//  DriverMenuVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/16/22.
//

import UIKit

// Sections
private enum SectionType: String, CaseIterable {
    case name, type, payRate
    
    var title: String {
        switch self {
        case .payRate:
            return "Pay rate"
        default:
            return self.rawValue.capitalized
        }
    }
}

// MARK: - DriverMenuVC
class DriverMenuVC: UIViewController {
    
    let tableView = UITableView()
    let saveButton = TRButton(title: "SAVE", type: .light)
    
    private let sections = SectionType.allCases
    
    let minPayRate: Float = 0
    let maxPayRate: Float = 100
    let companyDriverRate: Float = 28
    let ownerOperatorRate: Float = 88
    
    
    lazy var currentPayRate: Float = {
        return isOwnerOperator ? ownerOperatorRate : companyDriverRate
    }()
    
    var isTeamDriver = false {
        didSet {
            if isTeamDriver {
                currentPayRate = currentPayRate / 2
            } else {
                currentPayRate = currentPayRate * 2 > maxPayRate ? maxPayRate : currentPayRate * 2
            }
            
            tableView.reloadSections([2], with: .none)
        }
    }
    
    var isOwnerOperator = true {
        didSet {
            currentPayRate = isOwnerOperator ? ownerOperatorRate : companyDriverRate
            tableView.reloadSections([2], with: .none)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        configureTableView()
        configureSaveButton()
    }
    
    // UI
    func layoutUI() {
        view.addSubviews(tableView, saveButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding / 2),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding / 2),
            tableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -padding)
        ])
    }
    
    // Config
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = .clear
        
        tableView.register(TRItemCell.nib, forCellReuseIdentifier: TRItemCell.identifier)
        tableView.register(DriverTypeCell.nib, forCellReuseIdentifier: DriverTypeCell.identifier)
        tableView.register(DriverPayRateCell.nib, forCellReuseIdentifier: DriverPayRateCell.identifier)
    }
    
    func configureSaveButton() {
        saveButton.dropShadow(color: .white.withAlphaComponent(0.25))
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    @objc func saveButtonPressed() { }

}


// MARK: - UITableViewDelegate
extension DriverMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .name: return 50
        case .type: return 210
        case .payRate: return 120
        }
    }
}

// MARK: - UITableViewDataSource
extension DriverMenuVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: TRItemCell.identifier,
                                                     for: indexPath) as! TRItemCell
            cell.itemName = section.title
            cell.itemValue = "Driver"
            
            return cell
        case .type:
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverTypeCell.identifier,
                                                     for: indexPath) as! DriverTypeCell
            cell.isTeamDriver = false
            cell.isOwnerOperator = true
            
            cell.teamTypeSelected = { isTeamDriver in
                self.isTeamDriver = isTeamDriver
            }
            
            cell.ownerTypeSelected = { isOwnerOperator in
                self.isOwnerOperator = isOwnerOperator
            }
            
            return cell
        case .payRate:
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverPayRateCell.identifier,
                                                     for: indexPath) as! DriverPayRateCell
            cell.minPayRate = minPayRate
            cell.maxPayRate = maxPayRate
            cell.payRate = currentPayRate
            
            cell.payRateChanged = { payRate in
                self.currentPayRate = payRate
            }
            
            return cell
        }
    }
}
