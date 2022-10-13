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
        configureTableView()
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
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        switch category {
        case .gross:
            tableView.register(GrossCell.nib, forCellReuseIdentifier: GrossCell.identifier)
        case .miles:
            tableView.register(MilesCell.nib, forCellReuseIdentifier: MilesCell.identifier)
        case .expenses:
            tableView.register(ExpensesCell.nib, forCellReuseIdentifier: ExpensesCell.identifier)
        case .fuel:
            tableView.register(FuelCell.nib, forCellReuseIdentifier: FuelCell.identifier)
        }
    }
    
    
    func presentCategoryItemNavController() {
        let categoryItemNavController = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.categoryItemNavigationController) as! UINavigationController
        self.present(categoryItemNavController, animated: true)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension TrackerCategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch category {
        case .gross:
            cell = tableView.dequeueReusableCell(withIdentifier: GrossCell.identifier) as! GrossCell
        case .miles:
            cell = tableView.dequeueReusableCell(withIdentifier: MilesCell.identifier) as! MilesCell
        case .expenses:
            cell = tableView.dequeueReusableCell(withIdentifier: ExpensesCell.identifier) as! ExpensesCell
        case .fuel:
            cell = tableView.dequeueReusableCell(withIdentifier: FuelCell.identifier) as! FuelCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return category == .expenses ? 40 : 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presentCategoryItemNavController()
    }
}
