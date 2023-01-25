//
//  DataMenuVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/26/22.
//

import UIKit

//MARK: - Data Menu Type
private enum MenuType: String, CaseIterable {
    case reset, sync, export
    
    var title: String {
        return rawValue.capitalized
    }
    
    var actionButtonType: TRButtonType {
        switch self {
        case .reset:
            return .red
        case .sync:
            return .light
        case .export:
            return .dark
        }
    }
}

private enum SectionType: String {
    case resetOptions
    case syncBenefits
    case exportPeriod, exportCategories
    
    var title: String {
        switch self {
        case .resetOptions:
            return "Options"
        case .syncBenefits:
            return "Benefits"
        case .exportPeriod:
            return "Period"
        case .exportCategories:
            return "Categories"
        }
    }
    
}

private enum RowType: String {
    case eraseHistory, resetApp
    case accessInfo, backUpData, useiCloud
    case exportFromTo, selectExportCategory
    
    var title: String? {
        switch self {
        case .eraseHistory:
            return "Erase history"
        case .resetApp:
            return "Reset app"
        default:
            return nil
        }
    }
    
    var description: String? {
        switch self {
        case .eraseHistory:
            return "Remove all added data but keep \npersonal info and app configuration"
        case .resetApp:
            return "Delete profile, all assosiated data \nand reset app configuration"
        case .accessInfo:
            return "Access your info \nacross different devices"
        case .backUpData:
            return "Back up your data \nin case you lose your phone"
        case .useiCloud:
            return "Use your iCloud \nto securely store it with Apple"
        default:
            return ""
        }
    }
    
    var image: UIImage? {
        switch self {
        case .accessInfo:
            return SFSymbols.repeatArrows
        case .backUpData:
            return SFSymbols.macStudio
        case .useiCloud:
            return SFSymbols.macPro
        default:
            return nil
        }
    }
}

private struct Section {
    var type: SectionType
    var rows: [RowType]
}

//MARK: - DataMenuVC
class DataMenuVC: UIViewController {
    
    let segmentControl = TRSegmentedControl()
    let tableView = UITableView()
    var actionButton = TRButton()
    
    private var sections = [Section]()
    private var selectedResetOptionIndex: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var selectedMenu: MenuType = .sync {
        didSet {
            updateSections()
            tableView.reloadData()
            actionButton.set(title: selectedMenu.title, type: selectedMenu.actionButtonType)
        }
    }
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
        updateSections()
        configureSegmentedControl()
        configureTableView()
        configureActionButton()
    }
    
    // UI
    private func layoutUI() {
        view.addSubviews(segmentControl, tableView, actionButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let segmentControlPadding: CGFloat = 10
        let tableViewPadding: CGFloat = 20
        NSLayoutConstraint.activate([
            segmentControl.heightAnchor.constraint(equalToConstant: 35),
            segmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: segmentControlPadding),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: segmentControlPadding),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -segmentControlPadding),
            
            actionButton.heightAnchor.constraint(equalToConstant: 45),
            actionButton.widthAnchor.constraint(equalToConstant: 200),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: tableViewPadding),
            
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -tableViewPadding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: tableViewPadding / 2),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -tableViewPadding / 2)
        ])
    }

    // Configuration
    private func updateSections() {
        switch selectedMenu {
        case .reset:
            sections = [Section(type: .resetOptions, rows: [.eraseHistory, .resetApp])]
        case .sync:
            sections = [Section(type: .syncBenefits, rows: [.accessInfo, .backUpData, .useiCloud])]
        case .export:
            sections = [Section(type: .exportPeriod, rows: [.exportFromTo]),
                        Section(type: .exportCategories, rows: [.selectExportCategory])]
        }
    }
    
    private func configureSegmentedControl() {
        var titles = [String]()
        MenuType.allCases.forEach { titles.append($0.title) }
        
        segmentControl.createButtons(with: titles, selectedIndex: 1)
        segmentControl.delegate = self
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        
        tableView.register(TRHeaderView.self, forHeaderFooterViewReuseIdentifier: TRHeaderView.identifier)
        tableView.register(SyncInfoCell.nib, forCellReuseIdentifier: SyncInfoCell.identifier)
        tableView.register(ResetOptionCell.nib, forCellReuseIdentifier: ResetOptionCell.identifier)
        tableView.register(ExportPeriodCell.nib, forCellReuseIdentifier: ExportPeriodCell.identifier)
        tableView.register(ExportCategoriesCell.nib, forCellReuseIdentifier: ExportCategoriesCell.identifier)
    }
    
    func configureActionButton() {
        actionButton.set(title: selectedMenu.title, type: selectedMenu.actionButtonType)
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
    }
    
    @objc func actionButtonPressed() { }
}

// MARK: - TRSegmentedControlDelegate
extension DataMenuVC: TRSegmentedControlDelegate {
    func didSelectItem(at index: Int) {
        selectedMenu = MenuType.allCases[index]
    }
}

// MARK: - UITableViewDelegate
extension DataMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TRHeaderView.identifier)
                                                                                        as! TRHeaderView
        
        headerView.labelCenterYPadding = 1
        headerView.titleColor = .lightWhite
        headerView.title = sections[section].type.title
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = sections[indexPath.section].type
        switch sectionType {
        case.resetOptions:
            return 90
        case .syncBenefits:
            return 55
        case .exportPeriod:
            return 100
        case .exportCategories:
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionType = sections[indexPath.section].type
        switch sectionType {
        case .resetOptions:
            selectedResetOptionIndex = indexPath.row
        case .exportPeriod:
            // TODO: Show DatePicker
            break
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension DataMenuVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = sections[indexPath.section].type
        let rowType = sections[indexPath.section].rows[indexPath.row]
        switch sectionType {
            
        case .resetOptions:
            let cell = tableView.dequeueReusableCell(withIdentifier: ResetOptionCell.identifier, for: indexPath)
                                                                                        as! ResetOptionCell
            cell.optionTitle = rowType.title
            cell.optionDescription = rowType.description
            cell.optionIsSelected = indexPath.row == selectedResetOptionIndex
            return cell
            
        case .syncBenefits:
            let cell = tableView.dequeueReusableCell(withIdentifier: SyncInfoCell.identifier, for: indexPath)
                                                                                        as! SyncInfoCell
            cell.infoImage = rowType.image
            cell.infoDescription = rowType.description
            return cell
            
        case .exportPeriod:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExportPeriodCell.identifier, for: indexPath)
                                                                                            as! ExportPeriodCell
            cell.startDate = Date(timeIntervalSinceNow: -60*60*24*7)
            cell.endDate = Date()
            return cell
            
        case .exportCategories:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExportCategoriesCell.identifier, for: indexPath)
                                                                                            as! ExportCategoriesCell
            return cell
        }
    }
}
