//
//  DashboardViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/30/23.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var incomeAmountLabel: UILabel!
    @IBOutlet private var segmentedControlView: UIView!
    @IBOutlet private var periodContainerView: UIView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var tableView: UITableView!
    
    private let viewModel = DashboardViewModel()
    private var segmentedControl: TRSegmentedControl!
    private let periodDisplayVC = PeriodDisplayViewController()

    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        updateHeaderHeight()
        configureSegmentedControl()
        addPeriodDisplayVC()
        configureTableView()
        
        updateData()
        addObservers()
        addSwipeGestures()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureHeader()
    }
    
    deinit { removeObservers() }
    

    // UI Configuration
    private func configureNavBar() {
        navigationItem.title = "Income"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: AppColors.textColor]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: SFSymbols.chartLine, style: .plain,
                                                           target: self, action: #selector(displayChart))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.squareArrowUp, style: .plain,
                                                            target: self, action: #selector(showExportVC))
        navigationItem.leftBarButtonItem?.tintColor = AppColors.textColor
        navigationItem.rightBarButtonItem?.tintColor = AppColors.textColor
    }
    
    @objc private func displayChart() {
        //TODO: Display chart
    }
    
    @objc private func showExportVC() {
        //TODO: Show Export VC
    }
    
    private func updateHeaderHeight() {
        headerViewHeightConstraint.constant = DeviceTypes.isiPhoneSE ? 190 : 230
    }
    
    private func configureHeader() {
        headerView.dropShadow(opacity: 0.3)
        headerView.applyGradient(colors: AppColors.headerColors, locations: [0, 1])
    }
    
    private func updateIncomeLabel() {
        let currency = UDManager.shared.currency.symbol
        let income = viewModel.totalIncome.formattedWithSeparator()
        incomeAmountLabel.text = currency + " " + income
    }

    
    // Segmented Control
    private func configureSegmentedControl() {
        segmentedControl = TRSegmentedControl(frame: segmentedControlView.bounds)
        segmentedControlView.addSubview(segmentedControl)
        segmentedControl.pinToEdges(of: segmentedControlView)
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        updateSegmentedControl()
    }
    
    private func updateSegmentedControl() {
        let titles = viewModel.segmentTitles
        let subtitles = viewModel.segmentSubtitles
        segmentedControl.configure(with: titles, subtitles: subtitles, type: .underline,
                                               selectedIndex: viewModel.selectedSegment)
    }
    
    @objc private func segmentChanged(_ sender: TRSegmentedControl) {
        guard viewModel.selectedSegment != sender.selectedIndex else { return }
        
        let isNextSegment = sender.selectedIndex > viewModel.selectedSegment
        viewModel.selectedSegment = sender.selectedIndex
        updateTableView(animateLeft: isNextSegment)
        updatePeriodDisplay()
    }
    
    
    // Gestures
    private func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.cancelsTouchesInView = true
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        swipeRight.cancelsTouchesInView = true
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        var currentSegment = viewModel.selectedSegment
        
        if sender.direction == .left && currentSegment < (viewModel.segments.count - 1) {
            currentSegment += 1
            viewModel.selectedSegment = currentSegment
            segmentedControl.selectSegment(currentSegment)
            updateTableView(animateLeft: true)
            
        } else if sender.direction == .right && currentSegment > 0 {
            currentSegment -= 1
            viewModel.selectedSegment = currentSegment
            segmentedControl.selectSegment(currentSegment)
            updateTableView(animateLeft: false)
        }
        
        updatePeriodDisplay()
    }
    
    
    // Period
    private func addPeriodDisplayVC() {
        addChild(periodDisplayVC)
        periodContainerView.roundEdges()
        periodContainerView.dropShadow(opacity: 0.1)
        periodContainerView.addSubview(periodDisplayVC.view)
        periodDisplayVC.view.frame = periodContainerView.bounds
        
        periodDisplayVC.delegate = self
        periodDisplayVC.didMove(toParent: self)
        updatePeriodDisplay()
    }
    
    private func updatePeriodDisplay() {
        periodDisplayVC.period = viewModel.dashboardPeriod
        periodDisplayVC.numberOfItems = viewModel.numberOfItems
        periodDisplayVC.itemName = viewModel.selectedSegmentSubtitle
    }
    
    
    // Navigation
    private func showPeriodSelectorVC() {
        let periodSelectorVC = PeriodSelectorViewController(selectedPeriod: viewModel.dashboardPeriod)
        periodSelectorVC.delegate = self
        present(periodSelectorVC, animated: true)
    }
    
    private func showItemEntryVC(for row: Int) {
        guard let itemModel = viewModel.model(at: row) else {
            self.showAlert(title: "Error", message: "Failed to retrieve item.")
            return
        }
        
        let itemEntryVC = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.itemEntryViewController) as! ItemEntryViewController
        let itemNavController = UINavigationController(rootViewController: itemEntryVC)
        
        itemEntryVC.setupViewModel(with: itemModel)
        self.present(itemNavController, animated: true)
    }
    
    // TableView
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExpenseSummaryCell.nib, forCellReuseIdentifier: ExpenseSummaryCell.identifier)
        tableView.register(LoadSummaryCell.nib, forCellReuseIdentifier: LoadSummaryCell.identifier)
        tableView.register(FuelSummaryCell.nib, forCellReuseIdentifier: FuelSummaryCell.identifier)
    }
    
    private func updateTableView(animateLeft: Bool) {
        tableView.reloadSections(IndexSet(integer: 0), with: animateLeft ? .left : .right)
    }
    
    // Data
    private func updateData() {
        activityIndicator.startAnimating()
        viewModel.fetchData() { [weak self] success in
            guard success else { return }
            
            self?.updateIncomeLabel()
            self?.updateSegmentedControl()
            self?.updatePeriodDisplay()
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
    }
    
    // Notifications
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground),
                                           name: UIApplication.willEnterForegroundNotification,
                                           object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)),
                                               name: .distanceUnitChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)),
                                               name: .currencyChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)),
                                               name: .weekStartDayChanged, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification,
                                                                                      object: nil)
        NotificationCenter.default.removeObserver(self, name: .distanceUnitChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .currencyChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .weekStartDayChanged, object: nil)
    }
    
    @objc private func appWillEnterForeground() {
        segmentedControl.selectSegment(viewModel.selectedSegment)
    }
    
    @objc private func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .distanceUnitChanged:
            guard viewModel.selectedSegment == 1 else { return } //Load
            updateData()
            
        case .currencyChanged:
            updateData()
            
        case .weekStartDayChanged:
            guard viewModel.dashboardPeriod.type == .week else { return }
            
            // get current middle date
            // create new interval based on Calendar.firstWeekday
            let middleDate = viewModel.dashboardPeriod.interval.middleDate()
            let newInterval = middleDate.getDateInterval(in: .week)
            viewModel.dashboardPeriod = Period(type: .week, interval: newInterval)
            updateData()
            
        default:
            break
        }
    }
}


// MARK: - Period Display Delegate
extension DashboardViewController: PeriodDisplayDelegate {
    func didTapPeriod() {
        showPeriodSelectorVC()
    }
    
    func didUpdatePeriod(with newPeriod: Period) {
        viewModel.dashboardPeriod = newPeriod
        updateData()
    }
}

// MARK: - Period Selector Delegate
extension DashboardViewController: PeriodSelectorDelegate {
    func selectorDidUpdate(period: Period) {
        viewModel.dashboardPeriod = period
        updateData()
    }
}

// MARK: - UITableView DataSource
extension DashboardViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfItems == 0 {
            tableView.setEmptyView(title: viewModel.emptyTableTitle, message: viewModel.emptyTableMessage)
        } else {
            tableView.restore()
        }
        
        return viewModel.numberOfItems
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.selectedSegmentType {
        case .expense:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseSummaryCell.identifier)
                                                                        as! ExpenseSummaryCell
            let viewModel = viewModel.expenseCellViewModel(for: indexPath)
            cell.configure(with: viewModel)
            return cell
            
        case .load:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadSummaryCell.identifier)
                                                                        as! LoadSummaryCell
            let viewModel = viewModel.loadCellViewModel(for: indexPath)
            cell.configure(with: viewModel)
            return cell
            
        case .fuel:
            let cell = tableView.dequeueReusableCell(withIdentifier: FuelSummaryCell.identifier)
                                                                        as! FuelSummaryCell
            let viewModel = viewModel.fuelCellViewModel(for: indexPath)
            cell.configure(with: viewModel)
            return cell
        }
    }
}

// MARK: - UITableView Delegate
extension DashboardViewController: UITableViewDelegate {
    // Height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.selectedSegmentType {
        case .expense, .fuel:
            return 80 + 15
        case .load:
            return 95 + 15
        }
    }
    
    // Selection
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) {
            cell?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.2) { [weak self] in
            cell?.transform = CGAffineTransform.identity
            self?.showItemEntryVC(for: indexPath.row)
        }
    }
}

