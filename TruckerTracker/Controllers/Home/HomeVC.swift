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
    
    var segmentedControl: TRSegmentedControl!
    var selectedItemType: ItemType = .load
    let itemTypes = ItemType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        addSwipeGestures()
        configureSegmentedControl()
    }
    
    override func viewDidLayoutSubviews() {
        configureHeader()
    }
    
    // Configuration
    func configureNavBar() {
        navigationItem.title = "Income"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:
                                                            AppColors.textColor]
    }
    
    func configureHeader() {
        headerView.dropShadow()
        headerView.applyGradient(colors: AppColors.headerColors, locations: [0, 1])
    }
    
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
}
