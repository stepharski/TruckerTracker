//
//  DocumentsMenuVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/22/22.
//

import UIKit

// Sections
private enum SectionType: CaseIterable {
    case rateConfirmations, fuelReceipts, others
    
    var name: String {
        switch self {
        case .rateConfirmations:
            return "Rate confirmations"
        case .fuelReceipts:
            return "Fuel receipts"
        case .others:
            return "Others"
        }
    }
}

private struct Section {
    var type: SectionType
    var isExpanded: Bool
}

// MARK: - DocumentsMenuVC
class DocumentsMenuVC: UIViewController {

    let periodContainerView = UIView()
    let periodDisplayVC = TRPeriodDisplayVC()
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let addDocButton = TRButton(title: "ADD DOCUMENT", type: .dark)
    
    private var sections = [Section]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        configureSections()
        configureTableView()
        configureAddDocButton()
        addPeriodDisplayChildVC()
    }

    
    // UI
    func layoutUI() {
        view.addSubviews(periodContainerView, tableView, addDocButton)
        
        periodContainerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            periodContainerView.heightAnchor.constraint(equalToConstant: 60),
            periodContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            periodContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            periodContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addDocButton.heightAnchor.constraint(equalToConstant: 45),
            addDocButton.widthAnchor.constraint(equalToConstant: 200),
            addDocButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addDocButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding),
            
            tableView.topAnchor.constraint(equalTo: periodContainerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding / 2),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding / 2),
            tableView.bottomAnchor.constraint(equalTo: addDocButton.topAnchor, constant: -padding)
        ])
    }
    
    // Configuration
    func configureSections() {
        sections = [Section(type: .rateConfirmations, isExpanded: false),
                    Section(type: .fuelReceipts, isExpanded: false),
                    Section(type: .others, isExpanded: false)]
    }
    
    func addPeriodDisplayChildVC() {
        periodDisplayVC.delegate = self
        periodDisplayVC.itemName = "Document"
        
        addChild(periodDisplayVC)
        periodContainerView.roundEdges()
        periodContainerView.backgroundColor = .clear
        periodContainerView.addSubview(periodDisplayVC.view)
        
        periodDisplayVC.view.frame = periodContainerView.bounds
        periodDisplayVC.didMove(toParent: self)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 40
        tableView.backgroundColor = .clear
        tableView.register(AttachmentCell.nib, forCellReuseIdentifier: AttachmentCell.identifier)
        tableView.register(ExpandFooterView.self, forHeaderFooterViewReuseIdentifier: ExpandFooterView.identifier)
        tableView.register(SectionTitleHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionTitleHeaderView.identifier)
    }
    
    func configureAddDocButton() {
        addDocButton.addTarget(self, action: #selector(addDocButtonPressed), for: .touchUpInside)
    }
    
    @objc func addDocButtonPressed() { }
    
    // Navigation
    func showPeriodSelectorVC() {
        let periodSelectorVC = TRPeriodSelectorVC()
        periodSelectorVC.delegate = self
        present(periodSelectorVC, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension DocumentsMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                    SectionTitleHeaderView.identifier) as! SectionTitleHeaderView
        headerView.title = sections[section].type.name
        headerView.titleColor = .fadedWhite
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExpandFooterView.identifier)
                                                                                    as! ExpandFooterView
        footerView.isExpanded = sections[section].isExpanded
        
        footerView.didTapExpandButton = {
            self.sections[section].isExpanded = !self.sections[section].isExpanded
            self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: - UITableViewDataSource
extension DocumentsMenuVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].isExpanded ? 10 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentCell.identifier,
                                                 for: indexPath) as! AttachmentCell
        let randomInt = Int.random(in: 1...1000)
        switch sections[indexPath.section].type {
        case .rateConfirmations:
            cell.title = "LoadConfirmation\(randomInt)"
        case . fuelReceipts:
            cell.title = "FuelReceipt\(randomInt)"
        case .others:
            cell.title = "Document\(randomInt)"
        }
        
        return cell
    }
}

//MARK: - PeriodDisplayDelegate
extension DocumentsMenuVC: PeriodDisplayDelegate {
    func didTapPeriodDisplay() {
        showPeriodSelectorVC()
    }

    func displayDidUpdate(period: Period) {
        //TODO: Fetch data for new period
        print("DocumentsMenuFetchDataDisplay")
    }
}

// MARK: - PeriodSelectorDelegate
extension DocumentsMenuVC: PeriodSelectorDelegate {
    func selectorDidUpdate(period: Period) {
        periodDisplayVC.period = period
        //TODO: Fetch data for new period
        print("DocumentsMenuFetchDataSelector")
    }
}
