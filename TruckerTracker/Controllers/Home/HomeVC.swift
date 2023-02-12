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
    
    var segmentedControl: TRSegmentedControl!
    
    let itemTypes = ItemType.allCases
    var selectedItemType: ItemType = .load {
        didSet { periodDisplayVC.itemName = selectedItemType.subtitle }}
    
    let periodDisplayVC = TRPeriodDisplayVC()
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        addSwipeGestures()
        configureSegmentedControl()
        addPeriodDisplayChildVC()
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
        headerView.dropShadow()
        headerView.applyGradient(colors: AppColors.headerColors, locations: [0, 1])
    }

    
    // Segmented Control
    func configureSegmentedControl() {
        let titles = ["$1,600", "$4,200", "$3,120"]
        var subtitles = [String]()
        ItemType.allCases.forEach { subtitles.append($0.pluralTitle) }
        
        segmentedControl = TRSegmentedControl(frame: segmentedControlView.bounds)
        segmentedControlView.addSubview(segmentedControl)
        segmentedControl.pinToEdges(of: segmentedControlView)
        
        segmentedControl.configure(with: titles, subtitles: subtitles,
                                   type: .underline, selectedIndex: selectedItemType.index)
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentChanged(_ sender: TRSegmentedControl) {
        if itemTypes.indices.contains(sender.selectedIndex) {
            selectedItemType = itemTypes[sender.selectedIndex]
        }
    }
    
    // Period
    func addPeriodDisplayChildVC() {
        periodDisplayVC.delegate = self
        periodDisplayVC.itemName = selectedItemType.subtitle
        
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
        var currentSegment = selectedItemType.index
        
        if sender.direction == .left && currentSegment < (itemTypes.count - 1) {
            currentSegment += 1
            selectedItemType = itemTypes[currentSegment]
            segmentedControl.selectSegment(at: currentSegment)
            
        } else if sender.direction == .right && currentSegment > 0 {
            currentSegment -= 1
            selectedItemType = itemTypes[currentSegment]
            segmentedControl.selectSegment(at: currentSegment)
        }
    }
    
    // Navigation
    func showPeriodSelectorVC() {
        let periodSelectorVC = TRPeriodSelectorVC()
        periodSelectorVC.delegate = self
        present(periodSelectorVC, animated: true)
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
