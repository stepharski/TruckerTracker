//
//  FilterOptionsViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/24/23.
//

import UIKit

// MARK: - Filter Options Selector Delegate
protocol FilterOptionsSelectorDelegate: AnyObject {
    func filterOptionsSelected(period: Period, categories: Set<ItemType>)
}

// MARK: - Sections Rows Definition
private enum Section {
    case period
    case categories(items: [ItemType])
    
    var title: String {
        switch self {
        case .period:     return "Period"
        case .categories:  return "Categories"
        }
    }
}

// MARK: - FilterOptions ViewController
class FilterOptionsViewController: UIViewController {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let resetButton = UIButton()
    private let closeButton = UIButton()
    private let tableView = UITableView()
    private let applyButton = ActionButton()
    
    private var sections = [Section]()
    
    weak var delegate: FilterOptionsSelectorDelegate?
    
    var selectedPeriod: Period = UDManager.shared.dashboardPeriod
    var selectedCategories: Set<ItemType> = [.expense, .fuel, .load]
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContainerView()
        
        layoutUI()
        configureTitleLabel()
        configureResetButton()
        configureCloseButton()
        configureApplyButton()
        
        addSectionsRows()
        configureTableView()
    }

    // Dismiss on background tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first else { return }

        let location = touch.location(in: view)
        if !containerView.frame.contains(location) {
            self.dismiss(animated: true)
        }
    }
    
    // Sections configuration
    func addSectionsRows() {
        sections = [
            Section.period,
            Section.categories(items: [.expense, .load, .fuel])
        ]
    }
    
    // Container View
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.roundEdges(by: 10)
        containerView.backgroundColor = .systemGray6
        
        let minimumHeight: CGFloat = 500
        let computedHeight: CGFloat = 0.65 * view.bounds.height
        let containerHeight: CGFloat = computedHeight < minimumHeight ? minimumHeight
                                                                     : computedHeight
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
    }
    
    // Layout
    private func layoutUI() {
        [titleLabel, resetButton, closeButton, tableView, applyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            
            resetButton.widthAnchor.constraint(equalToConstant: 70),
            resetButton.heightAnchor.constraint(equalToConstant: 45),
            resetButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            resetButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            
            closeButton.widthAnchor.constraint(equalToConstant: 45),
            closeButton.heightAnchor.constraint(equalToConstant: 45),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            
            applyButton.widthAnchor.constraint(equalToConstant: 300),
            applyButton.heightAnchor.constraint(equalToConstant: 45),
            applyButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            applyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    // Configuration
    private func configureTitleLabel() {
        titleLabel.text = "Filter"
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func configureResetButton() {
        var config = UIButton.Configuration.plain()
        config.title = "Reset"
        config.baseForegroundColor = .label
        resetButton.configuration = config
        
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    @objc func resetButtonTapped() {
        selectedPeriod = UDManager.shared.dashboardPeriod
        selectedCategories = [.expense, .load, .fuel]
        tableView.reloadData()
    }
    
    private func configureCloseButton() {
        var config = UIButton.Configuration.plain()
        config.image = SFSymbols.xmark
        config.baseForegroundColor = .label
        closeButton.configuration = config
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        
        tableView.register(CustomPeriodCell.nib, forCellReuseIdentifier: CustomPeriodCell.identifier)
        tableView.register(FilterOptionCell.nib, forCellReuseIdentifier: FilterOptionCell.identifier)
        tableView.register(SectionTitleHeaderView.self, forHeaderFooterViewReuseIdentifier:
                                                    SectionTitleHeaderView.identifier)
    }
    
    private func configureApplyButton() {
        applyButton.set(title: "APPLY", action: .confirm, shape: .rectangle)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func applyButtonTapped() {
        delegate?.filterOptionsSelected(period: selectedPeriod, categories: selectedCategories)
        self.dismiss(animated: true)
    }
}


// MARK: - UITableView DataSource
extension FilterOptionsViewController: UITableViewDataSource {
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section]{
        case .period:
            return 1
        case .categories(let items):
            return items.count
        }
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .period:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomPeriodCell.identifier)
                                                                        as! CustomPeriodCell
            cell.startDate = selectedPeriod.interval.start
            cell.endDate = selectedPeriod.interval.end
            cell.delegate = self
            return cell
            
        case .categories(let items):
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterOptionCell.identifier)
                                                                        as! FilterOptionCell
            let item = items[indexPath.row]
            cell.optionTitle = item.pluralTitle.capitalized
            cell.isOptionSelected = selectedCategories.contains(item)
            
            return cell
        }
    }
}

// MARK: - UITableView Delegate
extension FilterOptionsViewController: UITableViewDelegate {
    // Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // Header View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                SectionTitleHeaderView.identifier) as! SectionTitleHeaderView
        headerView.labelCenterYPadding = -8
        headerView.titleColor = .dark
        headerView.titleSize = .large
        headerView.title = sections[section].title
        
        return headerView
    }
    
    // Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .period:
            return 130
        case .categories:
            return 45
        }
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .period:
            return
            
        case .categories(let items):
            let selectedItem = items[indexPath.row]
            
            if selectedCategories.count == 1
                && selectedCategories.contains(selectedItem) { return }
            
            selectedCategories.formSymmetricDifference([selectedItem])
            tableView.reloadData()
        }
    }
}

// MARK: - CustomPeriodCell Delegate
extension FilterOptionsViewController: CustomPeriodCellDelegate {
    func didSelect(startDate: Date, endDate: Date) {
        selectedPeriod.interval = DateInterval(start: startDate, end: endDate)
    }
}
