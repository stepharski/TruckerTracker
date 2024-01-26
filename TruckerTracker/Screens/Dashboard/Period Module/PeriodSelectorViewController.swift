//
//  PeriodSelectorViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/2/23.
//

import UIKit

// MARK: - PeriodSelector Delegate
protocol PeriodSelectorDelegate: AnyObject {
    func selectorDidUpdate(period: Period)
}

// MARK: - SectionsRows Definition
private enum SectionType: String {
    case period, types
    
    var title: String {
        return self.rawValue.capitalized
    }
}

private struct Section {
    var type: SectionType
    var rows: [PeriodType]
}


// MARK: - PeriodSelector ViewController
class PeriodSelectorViewController: UIViewController {
    
    weak var delegate: PeriodSelectorDelegate?
    
    private let containerView = UIView()
    private let closeButton = UIButton()
    private let periodLabel = UILabel()
    private let tableView = UITableView()
    private let applyButton = ActionButton()

    private var sections = [Section]()
    private var pickerSelectedRows = [Int]()
    private var pickerComponents = [[String]]()
    
    var selectedPeriod: Period! {
        didSet { updateUI() }
    }
    
    // Life cycle
    init(selectedPeriod: Period) {
        super.init(nibName: nil, bundle: nil)
        self.selectedPeriod = selectedPeriod
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
        
        layoutUI()
        configureCloseButton()
        configurePeriodLabel()
        configureApplyButton()
        
        updateUI()
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
            Section(type: .period, rows: []),
            Section(type: .types, rows: [.year, .month, .week, .customPeriod, .sinceYouStarted])
        ]
    }
    
    // Container View
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.roundEdges(by: 10)
        containerView.backgroundColor = .systemGray6
        
        let containerHeight: CGFloat = 590
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
    }
    

    // UI
    func layoutUI() {
        [closeButton, periodLabel, tableView, applyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            periodLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            periodLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding/2),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding/2),
            
            applyButton.widthAnchor.constraint(equalToConstant: 300),
            applyButton.heightAnchor.constraint(equalToConstant: 45),
            applyButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            applyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25),
            
            tableView.topAnchor.constraint(equalTo: periodLabel.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding)
        ])
    }
    
    func updateUI() {
        tableView.reloadData()
        periodLabel.text = selectedPeriod.convertToString()
        pickerComponents = generatePickerComponents()
        pickerSelectedRows = getPickerSelectedRows(in: pickerComponents)
    }
    
    
    // Configuration
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
    
    private func configurePeriodLabel() {
        periodLabel.text = selectedPeriod.convertToString()
        periodLabel.textColor = .label
        periodLabel.textAlignment = .center
        periodLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        
        tableView.register(SectionTitleHeaderView.self, forHeaderFooterViewReuseIdentifier:
                                                        SectionTitleHeaderView.identifier)
        tableView.register(PeriodPickerCell.nib, forCellReuseIdentifier: PeriodPickerCell.identifier)
        tableView.register(CustomPeriodCell.nib, forCellReuseIdentifier: CustomPeriodCell.identifier)
        tableView.register(PeriodTypeCell.nib, forCellReuseIdentifier: PeriodTypeCell.identifier)
    }
    
    private func configureApplyButton() {
        applyButton.set(title: "APPLY", action: .confirm, shape: .rectangle)
        applyButton.addTarget(self, action: #selector(applyPeriodSelection), for: .touchUpInside)
    }
    
    @objc func applyPeriodSelection() {
        delegate?.selectorDidUpdate(period: selectedPeriod)
        self.dismiss(animated: true)
    }
    
    // PickerView components
    func generatePickerComponents() -> [[String]] {
        var pickerData = [[String]]()
        var component1 = [String]()
        var component2 = [String]()
        
        switch selectedPeriod.type {
        case .week:
            // number of weeks in leap year
            (1...52).forEach { component1.append("Week \($0)") }
            
        case .month:
            // number of months in year
            (1...12).forEach { component1.append(DateFormatter().standaloneMonthSymbols[$0 - 1]) }
        default:
            break
        }
        
        if !component1.isEmpty {
            pickerData.append(component1)
        }
        
        // number of years
        let userSinceYear = UDValues.userSinceDate.yearNumber
        let selectedYear = selectedPeriod.interval.start.yearNumber
        let pickerMiddleYear = selectedYear < userSinceYear ? selectedYear
                                                            : userSinceYear
        ((pickerMiddleYear - 5)...(pickerMiddleYear + 5)).forEach {
            component2.append("\($0)")
        }
        
        pickerData.append(component2)
        
        return pickerData
    }
    
    // PickerView selected rows
    func getPickerSelectedRows(in components: [[String]]) -> [Int] {
        guard !components.isEmpty else { return [] }
        
        var selectedIndexes = [Int]()
        
        let calendar = Calendar.userCurrent()
        let date = selectedPeriod.interval.middleDate

        switch selectedPeriod.type {
        case .week:
            let week = calendar.component(.weekOfYear, from: date)
            if components.first != nil, components.first!.count >= week {
                selectedIndexes.append(week - 1)
            }

        case .month:
            let month = calendar.component(.month, from: date)
            if components.first != nil, components.first!.count >= month {
                selectedIndexes.append(month - 1)
            }
            
        default:
            break
        }

        let year = calendar.component(.year, from: date)
        if let index = components[components.count - 1].firstIndex(of: "\(year)") {
            selectedIndexes.append(index)
        }
        
        return selectedIndexes
    }
    
    // Update period from picker selected items
    func updatePeriodFromPicker(row: Int, component: Int) {
        guard pickerComponents.indices.contains(component) else { return }
        guard pickerComponents[component].indices.contains(row) else { return }

        let calendar = Calendar.userCurrent()
        var dateComponents = DateComponents()
        
        // first component in weekYear/monthYear/year picker
        if component == 0 {
            switch selectedPeriod.type {
            case .week:
                let year = selectedPeriod.interval.middleDate.yearNumber
                dateComponents = DateComponents(weekOfYear: row + 1, yearForWeekOfYear: year)
                
            case .month:
                dateComponents = DateComponents(year: selectedPeriod.interval.start.yearNumber, month: row + 1)
                
            case .year:
                let year = pickerComponents[component][row]
                dateComponents = DateComponents(year: Int(year))
                
            default:
                break
            }
            
            // year - second component in weekYear/mothYear picker
        } else if component == 1 {
            // change year
            let year = Int(pickerComponents[component][row])
            
            // keep week/month
            switch selectedPeriod.type {
            case .week:
                let week = calendar.component(.weekOfYear, from: selectedPeriod.interval.start)
                dateComponents = DateComponents(weekOfYear: week, yearForWeekOfYear: year)
                
            case .month:
                let month = calendar.component(.month, from: selectedPeriod.interval.start)
                dateComponents = DateComponents(year: year, month: month)
                
            default:
                break
            }
        }

        // update period
        if let date = calendar.date(from: dateComponents) {
            selectedPeriod.interval = date.getDateInterval(in: selectedPeriod.type)
        }
    }
}

// MARK: - UITableView DataSource
extension PeriodSelectorViewController: UITableViewDataSource {
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section].type {
        case .period:
            return 1
        case .types:
            return sections[section].rows.count
        }
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = sections[indexPath.section].type
        switch sectionType {
        case .period:
            switch selectedPeriod.type {
            case .week, .month, .year:
                let cell = tableView.dequeueReusableCell(withIdentifier: PeriodPickerCell.identifier)
                                                                            as! PeriodPickerCell
                cell.delegate = self
                cell.pickerData = pickerComponents
                cell.selectedRows = pickerSelectedRows
                return cell
                
            case .customPeriod, .sinceYouStarted:
                let cell = tableView.dequeueReusableCell(withIdentifier: CustomPeriodCell.identifier)
                                                                                as! CustomPeriodCell
                cell.startDate = selectedPeriod.interval.start
                cell.endDate = selectedPeriod.interval.end
                cell.delegate = self
                return cell
            }
        case .types:
            let cell = tableView.dequeueReusableCell(withIdentifier: PeriodTypeCell.identifier)
                                                                        as! PeriodTypeCell
            let rowType = sections[indexPath.section].rows[indexPath.row]
            cell.typeTitle = rowType.title
            cell.isTypeSelected = rowType == selectedPeriod.type
            return cell
        }
    }
}

// MARK: - UITableView Delegate
extension PeriodSelectorViewController: UITableViewDelegate {
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
        headerView.title = sections[section].type.title
        
        return headerView
    }
    
    // Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].type {
        case .period:
            return 130
        case .types:
            return 45
        }
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSection = sections[indexPath.section].type
        let selectedPeriodType = sections[indexPath.section].rows[indexPath.row]
        
        if selectedSection == .types {
            var newInterval = DateInterval()
            
            switch selectedPeriodType {
            case .week, .month, .year, .customPeriod:
                newInterval = Date().getDateInterval(in: selectedPeriodType)
                
            case .sinceYouStarted:
                newInterval = DateInterval(start: UDManager.shared.userSinceDate,
                                           end: .now.local.endOfDay)
            }
            
            selectedPeriod = Period(type: selectedPeriodType, interval: newInterval)
        }
    }
}

// MARK: - PeriodPickerCell Delegate
extension PeriodSelectorViewController: PeriodPickerCellDelegate {
    func pickerDidSelect(row: Int, component: Int) {
        updatePeriodFromPicker(row: row, component: component)
    }
}


// MARK: - CustomPeriodCell Delegate
extension PeriodSelectorViewController: CustomPeriodCellDelegate {
    func didSelect(startDate: Date, endDate: Date) {
        selectedPeriod.interval = DateInterval(start: startDate, end: endDate)
    }
}
