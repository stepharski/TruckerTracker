//
//  HomeViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var incomeAmountLabel: UILabel!
    
    @IBOutlet var segmentedControlView: UIView!
    @IBOutlet var periodContainerView: UIView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    let periodDisplayVC = PeriodDisplayViewController()
    var segmentedControl: TRSegmentedControl!
    
    let segments = ItemType.allCases
    var selectedSegment: ItemType = .load {
        didSet { updatePeriodDisplay() }}
    
    var homeViewModel = HomeViewModel()
    var homeDisplayPeriod = UDManager.shared.homeDisplayPeriod {
        didSet { UDManager.shared.homeDisplayPeriod = homeDisplayPeriod }
    }
    
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    // UI Configuration
    func configureNavBar() {
        navigationItem.title = "Income"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: AppColors.textColor]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: SFSymbols.chartLine, style: .plain,
                                                           target: self, action: #selector(displayChart))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFSymbols.squareArrowUp, style: .plain,
                                                            target: self, action: #selector(showExportVC))
        navigationItem.leftBarButtonItem?.tintColor = AppColors.textColor
        navigationItem.rightBarButtonItem?.tintColor = AppColors.textColor
    }
    
    @objc func displayChart() {
        //TODO: Display chart
    }
    
    @objc func showExportVC() {
        //TODO: Show Export VC
    }
    
    func updateHeaderHeight() {
        headerViewHeightConstraint.constant = DeviceTypes.isiPhoneSE ? 190 : 230
    }
    
    func configureHeader() {
        headerView.dropShadow(opacity: 0.3)
        headerView.applyGradient(colors: AppColors.headerColors, locations: [0, 1])
    }
    
    func updateIncomeLabel() {
        incomeAmountLabel.text = homeViewModel.getTotalIncome()
    }

    
    // Segmented Control
    func configureSegmentedControl() {
        segmentedControl = TRSegmentedControl(frame: segmentedControlView.bounds)
        segmentedControlView.addSubview(segmentedControl)
        segmentedControl.pinToEdges(of: segmentedControlView)
        
        updateSegmentedControl()
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    func updateSegmentedControl() {
        let titles = homeViewModel.getCategoryTotals()
        let subtitles = homeViewModel.getCategoryNames()
        segmentedControl.configure(with: titles, subtitles: subtitles, type: .underline,
                                                   selectedIndex: selectedSegment.index)
    }
    
    @objc func segmentChanged(_ sender: TRSegmentedControl) {
        guard segments.indices.contains(sender.selectedIndex)
                && selectedSegment.index != sender.selectedIndex else { return }
        
        let isNextSegment = sender.selectedIndex > selectedSegment.index
        selectedSegment = segments[sender.selectedIndex]
        updateTableView(animateLeft: isNextSegment)
    }
    
    
    // Gestures
    func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.cancelsTouchesInView = true
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        swipeRight.cancelsTouchesInView = true
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        var currentSegment = selectedSegment.index
        
        if sender.direction == .left && currentSegment < (segments.count - 1) {
            currentSegment += 1
            selectedSegment = segments[currentSegment]
            segmentedControl.selectSegment(at: currentSegment)
            updateTableView(animateLeft: true)
            
        } else if sender.direction == .right && currentSegment > 0 {
            currentSegment -= 1
            selectedSegment = segments[currentSegment]
            segmentedControl.selectSegment(at: currentSegment)
            updateTableView(animateLeft: false)
        }
    }
    
    
    // Period
    func addPeriodDisplayVC() {
        addChild(periodDisplayVC)
        periodContainerView.roundEdges()
        periodContainerView.dropShadow(opacity: 0.1)
        periodContainerView.addSubview(periodDisplayVC.view)
        periodDisplayVC.view.frame = periodContainerView.bounds
        
        periodDisplayVC.delegate = self
        periodDisplayVC.didMove(toParent: self)
        updatePeriodDisplay()
    }
    
    func updatePeriodDisplay() {
        periodDisplayVC.period = homeDisplayPeriod
        periodDisplayVC.itemName = selectedSegment.subtitle
        periodDisplayVC.numberOfItems = homeViewModel.getNumberOfItems(for: selectedSegment)
    }
    
    
    // Navigation
    func showPeriodSelectorVC() {
        let periodSelectorVC = PeriodSelectorViewController(selectedPeriod: homeDisplayPeriod)
        periodSelectorVC.delegate = self
        present(periodSelectorVC, animated: true)
    }
    
    func showItemDetailedVC(for row: Int) {
        let itemVC = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.itemViewController) as! ItemViewController
        let itemNavController = UINavigationController(rootViewController: itemVC)
        
        switch selectedSegment {
        case .expense:
            itemVC.expense = homeViewModel.expenses[safe: row]
            
        case .load:
            itemVC.load = homeViewModel.loads[safe: row]

        case .fuel:
            itemVC.fueling = homeViewModel.fuelings[safe: row]
        }
        
        self.present(itemNavController, animated: true)
    }
    
    // TableView
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ExpenseCell.nib, forCellReuseIdentifier: ExpenseCell.identifier)
        tableView.register(LoadCell.nib, forCellReuseIdentifier: LoadCell.identifier)
        tableView.register(FuelCell.nib, forCellReuseIdentifier: FuelCell.identifier)
    }
    
    func updateTableView(animateLeft: Bool) {
        tableView.reloadSections(IndexSet(integer: 0), with: animateLeft ? .left : .right)
    }
    
    // Data
    func updateData() {
        activityIndicator.startAnimating()
        homeViewModel.fetchData(for: homeDisplayPeriod) { [weak self] success in
            guard success else { return }
            
            self?.updateIncomeLabel()
            self?.updateSegmentedControl()
            self?.updatePeriodDisplay()
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
    }
    
    // Notifications
    func addObservers() {
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
    
    @objc func appWillEnterForeground() {
        segmentedControl.selectSegment(at: selectedSegment.index)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .distanceUnitChanged:
            guard selectedSegment == .load else { return }
            updateData()
            
        case .currencyChanged:
            updateData()
            
        case .weekStartDayChanged:
            guard homeDisplayPeriod.type == .week else { return }
            
            // get current middle date
            // create new interval based on Calendar.firstWeekday
            let middleDate = homeDisplayPeriod.interval.middleDate()
            let newInterval = middleDate.getDateInterval(in: .week)
            homeDisplayPeriod = Period(type: .week, interval: newInterval)
            updateData()
            
        default:
            break
        }
    }
}


// MARK: - Period Display Delegate
extension HomeViewController: PeriodDisplayDelegate {
    func didTapPeriod() {
        showPeriodSelectorVC()
    }
    
    func didUpdatePeriod(with newPeriod: Period) {
        homeDisplayPeriod = newPeriod
        updateData()
    }
}

// MARK: - Period Selector Delegate
extension HomeViewController: PeriodSelectorDelegate {
    func selectorDidUpdate(period: Period) {
        homeDisplayPeriod = period
        updateData()
    }
}

// MARK: - UITableView DataSource
extension HomeViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = homeViewModel.getNumberOfItems(for: selectedSegment)
        
        if numberOfRows == 0 {
            tableView.setEmptyView(title: "No \(selectedSegment.pluralTitle) found.",
                                   message: "Please, tap the '+' button to add a new \(selectedSegment.title).")
        } else {
            tableView.restore()
        }
        
        return numberOfRows
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedSegment {
        case .expense:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseCell.identifier) as! ExpenseCell
            let viewModel = homeViewModel.expenseCellViewModel(for: indexPath)
            cell.configure(with: viewModel)
            return cell
            
        case .load:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadCell.identifier) as! LoadCell
            let viewModel = homeViewModel.loadCellViewModel(for: indexPath)
            cell.configure(with: viewModel)
            return cell
            
        case .fuel:
            let cell = tableView.dequeueReusableCell(withIdentifier: FuelCell.identifier) as! FuelCell
            let viewModel = homeViewModel.fuelCellViewModel(for: indexPath)
            cell.configure(with: viewModel)
            return cell
        }
    }
}

// MARK: - UITableView Delegate
extension HomeViewController: UITableViewDelegate {
    // Height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedSegment {
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
            self?.showItemDetailedVC(for: indexPath.row)
        }
    }
}
