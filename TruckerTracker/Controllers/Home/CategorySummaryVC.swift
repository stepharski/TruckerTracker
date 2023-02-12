//
//  CategorySummaryVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/13/22.
//

import UIKit

class CategorySummaryVC: UIViewController {

    @IBOutlet var totalSumLabel: UILabel!
    @IBOutlet var symbolImageView: UIImageView!
    @IBOutlet var leadingStatiscitcsLabel: UILabel!
    @IBOutlet var trailingStatiscticsLabel: UILabel!
    
    @IBOutlet var periodContainerView: UIView!
    @IBOutlet var tableBackgroundView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var category = TrackerCategoryType.gross
    let periodDisplayVC = TRPeriodDisplayVC()
    
    // Lide cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureTableView()
        configureImageViews()
        addPeriodDisplayChildVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        applyGradients()
    }

    // UI
    func configureNavBar() {
        navigationItem.title = category.title.capitalized
    }
    
    func configureImageViews() {
        symbolImageView.image = category.image
        symbolImageView.tintColor = category.imageTintColor
    }
    
    func applyGradients() {
        view.applyGradient(colors: category.gradientColors, locations: category.gradientLocations)
        tableBackgroundView.applyGradient(colors: category.contrastGradientColors, locations: category.gradientLocations)
    }
    
    // Configuration
    func addPeriodDisplayChildVC() {
        periodDisplayVC.delegate = self
        periodDisplayVC.itemName = category.itemName
        
        addChild(periodDisplayVC)
        periodContainerView.roundEdges()
        periodContainerView.backgroundColor = .clear
        periodContainerView.addSubview(periodDisplayVC.view)
        
        periodDisplayVC.view.frame = periodContainerView.bounds
        periodDisplayVC.didMove(toParent: self)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableBackgroundView.roundEdges()
        
        switch category {
        case .gross, .miles:
            tableView.register(GrossMilesCell.nib, forCellReuseIdentifier: GrossMilesCell.identifier)
        case .expenses:
            tableView.register(ExpensesCell.nib, forCellReuseIdentifier: ExpensesCell.identifier)
        case .fuel:
            tableView.register(FuelCell.nib, forCellReuseIdentifier: FuelCell.identifier)
        }
    }
    
    // Navigation
    func presentCategoryItemNavController() {
        let categoryItemVC = self.storyboard?.instantiateViewController(
            withIdentifier: StoryboardIdentifiers.categoryItemVC) as! CategoryItemVC
        let categoryNavController = UINavigationController(rootViewController: categoryItemVC)
        self.present(categoryNavController, animated: true)
    }
    
    func showPeriodSelectorVC() {
        let periodSelectorVC = TRPeriodSelectorVC()
        periodSelectorVC.delegate = self
        present(periodSelectorVC, animated: true)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension CategorySummaryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch category {
        case .gross:
            cell = tableView.dequeueReusableCell(withIdentifier: GrossMilesCell.identifier) as! GrossMilesCell
        case .miles:
            cell = tableView.dequeueReusableCell(withIdentifier: GrossMilesCell.identifier) as! GrossMilesCell
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


//MARK: - PeriodDisplayDelegate
extension CategorySummaryVC: PeriodDisplayDelegate {
    func didTapPeriodDisplay() {
        showPeriodSelectorVC()
    }

    func displayDidUpdate(period: Period) {
        //TODO: Fetch data for new period
        print("CategorySummaryFetchDataDisplay")
    }
}

// MARK: - PeriodSelectorDelegate
extension CategorySummaryVC: PeriodSelectorDelegate {
    func selectorDidUpdate(period: Period) {
        periodDisplayVC.period = period
        //TODO: Fetch data for new period
        print("CategorySummaryFetchDataSelector")
    }
}
