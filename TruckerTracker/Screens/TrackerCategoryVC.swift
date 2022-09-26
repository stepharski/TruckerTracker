//
//  TrackerCategoryVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 9/3/22.
//

import UIKit

class TrackerCategoryVC: UIViewController {
    
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var leadingStatisticsLabel: UILabel!
    @IBOutlet weak var trailingStatisticsLabel: UILabel!
    @IBOutlet weak var symbolImageView: UIImageView!
    
    @IBOutlet weak var tableBackgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var category = TrackerCategoryType.gross
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        applyGradients()
    }

    
    func configureNavBar() {
        navigationItem.title = category.title.capitalized
    }
    
    func configureUI() {
        tableBackgroundView.layer.cornerRadius = 30
        symbolImageView.image = category.image
        symbolImageView.tintColor = category.imageTintColor
        
    }
    
    func applyGradients() {
        view.applyGradient(colors: category.gradientColors, locations: category.gradientLocations)
        tableBackgroundView.applyGradient(colors: category.contrastGradientColors, locations: category.gradientLocations)
    }
}
