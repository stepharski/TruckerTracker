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
    var selectedSegment: ItemType = .load {
        didSet {
            periodDisplayVC.itemName = selectedSegment.subtitle
            tableView.reloadData()
        }}
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        addSwipeGestures()
        configureSegmentedControl()
        addPeriodDisplayChildVC()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        configureHeader()
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
    func configureSegmentedControl() {
        let titles = ["$1,600", "$14,200", "$3,120"]
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch selectedSegment {
        case .expense:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseCell.identifier)
                                                                        as! ExpenseCell
            return cell
            
        case .load:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadCell.identifier)
                                                                        as! LoadCell
            return cell
            
        case .fuel:
            let cell = tableView.dequeueReusableCell(withIdentifier: FuelCell.identifier)
                                                                        as! FuelCell
            return cell
        }
    }
}
