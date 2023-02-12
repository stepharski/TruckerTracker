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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureHeader()
        configureSegmentedControl()
        
    }
    
    
    // Setup
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
        let titles = ["$1,600", "$14,200", "$3,120"]
        let subtitles = ["expenses", "loads", "fuel"]
        
        let segmentedControl = TRSegmentedControl(frame: segmentedControlView.bounds)
        segmentedControlView.addSubview(segmentedControl)
        segmentedControl.pinToEdges(of: segmentedControlView)
        segmentedControl.configure(with: titles, subtitles: subtitles, type: .underline)
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentChanged(_ sender: TRSegmentedControl) {
        print(sender.selectedIndex)
    }
}
