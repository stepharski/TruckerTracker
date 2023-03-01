//
//  HomeVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/9/23.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var incomeAmountLabel: UILabel!
    @IBOutlet var segmentedControlView: UIView!
    @IBOutlet var periodContainerView: UIView!
    @IBOutlet var tableView: UITableView!
    
    let periodDisplayVC = TRPeriodDisplayVC()
    var segmentedControl: TRSegmentedControl!
    
    let segments = ItemType.allCases
    var previousSelectedSegment: ItemType = .load
    
    var selectedSegment: ItemType = .load {
        didSet {
            guard selectedSegment != previousSelectedSegment else { return }
            updatePeriodDisplay()
            updateTableView()
            previousSelectedSegment = selectedSegment }}
    
    var expenses: [Expense] = []
    var loads: [Load] = []
    var fuelings: [Fuel] = []
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
        generateTestData()
        configureNavBar()
        addSwipeGestures()
        configureSegmentedControl()
        addPeriodDisplayChildVC()
        updatePeriodDisplay()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        configureHeader()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // Test data
    func generateTestData() {
        for i in 0..<5 {
            expenses.append(Expense(id: "expense\(i)",
                                    date: Date(),
                                    amount: 380,
                                    name: "Trailer rent",
                                    frequency: .week))
            
            loads.append(Load(id: "load\(i)",
                              date: Date(),
                              amount: 3200,
                              distance: 964,
                              startLocation: "Chicago, IL",
                              endLocation: "Atlanta, GA"))
            
            fuelings.append(Fuel(id: "fuel\(i)",
                                 date: Date(),
                                 amount: 540,
                                 type: .both))
        }
    }
    
    
    // Observer
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground),
                                           name: UIApplication.willEnterForegroundNotification,
                                           object: nil)
    }
    
    @objc func appWillEnterForeground() {
        segmentedControl.selectSegment(at: selectedSegment.index)
    }
    
    // UI Configuration
    func configureNavBar() {
        navigationItem.title = "Income"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:
                                                            AppColors.textColor]
    }
    
    func configureHeader() {
        headerView.dropShadow(opacity: 0.3)
        headerView.applyGradient(colors: AppColors.headerColors, locations: [0, 1])
    }

    
    // Segmented Control
    func getSegmentTitles() -> [String] {
        var expensesAmount = 0
        var loadsAmount = 0
        var fuelingsAmount = 0
        
        expenses.forEach { expensesAmount += $0.amount }
        loads.forEach { loadsAmount += $0.amount }
        fuelings.forEach { fuelingsAmount += $0.amount }
        
        return ["\(expensesAmount.formattedWithSeparator())",
                "\(loadsAmount.formattedWithSeparator())",
                "\(fuelingsAmount.formattedWithSeparator())"]
    }
    
    func configureSegmentedControl() {
        let titles = getSegmentTitles()
        var subtitles = [String]()
        ItemType.allCases.forEach { subtitles.append($0.pluralTitle) }
        
        segmentedControl = TRSegmentedControl(frame: segmentedControlView.bounds)
        segmentedControlView.addSubview(segmentedControl)
        segmentedControl.pinToEdges(of: segmentedControlView)
        
        segmentedControl.configure(with: titles, subtitles: subtitles,
                                   type: .underline, selectedIndex: selectedSegment.index)
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentChanged(_ sender: TRSegmentedControl) {
        if segments.indices.contains(sender.selectedIndex) {
            selectedSegment = segments[sender.selectedIndex]
        }
    }
    
    
    // Gestures
    func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        swipeRight.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        var currentSegment = selectedSegment.index
        
        if sender.direction == .left && currentSegment < (segments.count - 1) {
            currentSegment += 1
            selectedSegment = segments[currentSegment]
            segmentedControl.selectSegment(at: currentSegment)
            
        } else if sender.direction == .right && currentSegment > 0 {
            currentSegment -= 1
            selectedSegment = segments[currentSegment]
            segmentedControl.selectSegment(at: currentSegment)
        }
    }
    
    
    // Period
    func addPeriodDisplayChildVC() {
        periodDisplayVC.delegate = self
        periodDisplayVC.itemName = selectedSegment.subtitle
        
        addChild(periodDisplayVC)
        periodContainerView.roundEdges()
        periodContainerView.dropShadow(opacity: 0.1)
        periodContainerView.addSubview(periodDisplayVC.view)
        
        periodDisplayVC.view.frame = periodContainerView.bounds
        periodDisplayVC.didMove(toParent: self)
    }
    
    func updatePeriodDisplay() {
        periodDisplayVC.itemName = selectedSegment.subtitle
        
        switch selectedSegment {
        case .expense:
            periodDisplayVC.numberOfItems = expenses.count
        case .load:
            periodDisplayVC.numberOfItems = loads.count
        case .fuel:
            periodDisplayVC.numberOfItems = fuelings.count
        }
    }
    
    
    // Navigation
    func showPeriodSelectorVC() {
        let periodSelectorVC = TRPeriodSelectorVC()
        periodSelectorVC.delegate = self
        present(periodSelectorVC, animated: true)
    }
    
    
    // TableView
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ExpenseCell.nib, forCellReuseIdentifier: ExpenseCell.identifier)
        tableView.register(LoadCell.nib, forCellReuseIdentifier: LoadCell.identifier)
        tableView.register(FuelCell.nib, forCellReuseIdentifier: FuelCell.identifier)
    }
    
    func updateTableView() {
        let isNextSegment = selectedSegment.index > previousSelectedSegment.index
        tableView.reloadSections(IndexSet(integer: 0),
                                 with: isNextSegment ? .left : .right)
    }
}


// MARK: - PeriodDisplayDelegate
extension HomeVC: PeriodDisplayDelegate {
    func didTapPeriodDisplay() {
        showPeriodSelectorVC()
    }
    
    func displayDidUpdate(period: Period) {
        //TODO: Fetch data for new period
        print("HomeFetchDataDisplay")
    }
}

// MARK: - PeriodSelectorDelegate
extension HomeVC: PeriodSelectorDelegate {
    func selectorDidUpdate(period: Period) {
        periodDisplayVC.period = period
        
        //TODO: Fetch data for new period
        print("HomeFetchDataSelector")
    }
}


// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedSegment {
        case .expense, .fuel:
            return 80 + 15
        case .load:
            return 95 + 15
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegment {
        case .expense:
            return expenses.count
        case .load:
            return loads.count
        case .fuel:
            return fuelings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch selectedSegment {
        case .expense:
            guard !expenses.isEmpty else {
                // TODO: Show Empty State View
                return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseCell.identifier)
                                                                        as! ExpenseCell
            let viewModel = ExpenseCellViewModel(expenses[indexPath.row])
            cell.configure(with: viewModel)
            return cell
            
        case .load:
            guard !loads.isEmpty else {
                // TODO: Show Empty State View
                return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadCell.identifier)
                                                                        as! LoadCell
            let viewModel = LoadCellViewModel(loads[indexPath.row])
            cell.configure(with: viewModel)
            return cell
            
        case .fuel:
            guard !fuelings.isEmpty else {
                // TODO: Show Empty State View
                return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: FuelCell.identifier)
                                                                        as! FuelCell
            let viewModel = FuelCellViewModel(fuelings[indexPath.row])
            cell.configure(with: viewModel)
            return cell
        }
    }
}
