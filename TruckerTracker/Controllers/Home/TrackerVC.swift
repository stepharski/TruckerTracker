//
//  TrackerVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 9/3/22.
//

import UIKit

class TrackerVC: UIViewController {
    
    @IBOutlet var periodContainerView: UIView!
    @IBOutlet var categoryBackgroundViews: [UIView]!
    
    var periodDisplayVC = TRPeriodDisplayVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        addPeriodDisplayChildVC()
        configureCategoryViews()
        bindTapGestureToCategories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        applyGradients()
    }
    
    
    // UI Configuration
    func configureNavBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func addPeriodDisplayChildVC() {
        periodDisplayVC.delegate = self
        periodDisplayVC.itemName = "Load"
        
        addChild(periodDisplayVC)
        periodContainerView.roundEdges()
        periodContainerView.addSubview(periodDisplayVC.view)
        
        periodDisplayVC.view.frame = periodContainerView.bounds
        periodDisplayVC.didMove(toParent: self)
    }
    
    func configureCategoryViews() {
        guard categoryBackgroundViews.count == TrackerCategoryType.allCases.count else {
            return
        }
        
        categoryBackgroundViews.forEach { $0.roundEdges() }
        
        for index in categoryBackgroundViews.indices {
            let categoryType = TrackerCategoryType.allCases[index]
            let categoryInfoView = CategoryInfoView(categoryType: categoryType, withCount: 8800)
            let categoryBackgroundView = categoryBackgroundViews[index]
            categoryBackgroundView.addSubview(categoryInfoView)
            
            NSLayoutConstraint.activate([
                categoryInfoView.centerXAnchor.constraint(equalTo: categoryBackgroundView.centerXAnchor),
                categoryInfoView.centerYAnchor.constraint(equalTo: categoryBackgroundView.centerYAnchor)
            ])
        }
    }
    
    func applyGradients() {
        periodContainerView.applyGradient(colors: [#colorLiteral(red: 0.1529411765, green: 0.3294117647, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)], locations: [0, 1])
        
        guard categoryBackgroundViews.count == TrackerCategoryType.allCases.count else {
            return
        }
        
        for index in categoryBackgroundViews.indices {
            let categoryType = TrackerCategoryType.allCases[index]
            categoryBackgroundViews[index].applyGradient(colors: categoryType.gradientColors,
                                                         locations: categoryType.gradientLocations)
        }
    }
    
    // Gestures
    func bindTapGestureToCategories() {
        categoryBackgroundViews.forEach {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCategory(_:)))
            $0.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    
    @objc func didTapCategory(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view,
              let tappedViewIndex = categoryBackgroundViews.firstIndex(of: tappedView) else {
            return
        }
        
        let category = TrackerCategoryType.allCases[tappedViewIndex]
        showCategorySummaryVC(for: category)
    }
    
    
    // Navigation
    func showCategorySummaryVC(for category: TrackerCategoryType) {
        let categorySummaryVC = self.storyboard?
            .instantiateViewController(withIdentifier: StoryboardIdentifiers.categorySummaryVC) as! CategorySummaryVC
        
        categorySummaryVC.category = category
        navigationController?.pushViewController(categorySummaryVC, animated: true)
    }
    
    func showPeriodSelectorVC() {
        let periodSelectorVC = TRPeriodSelectorVC()
        periodSelectorVC.delegate = self
        present(periodSelectorVC, animated: true)
    }
}

//MARK: - TRPeriodDisplayVCDelegate
extension TrackerVC: TRPeriodDisplayVCDelegate {
    func didTapPeriodDisplay() {
        showPeriodSelectorVC()
    }

    func displayDidUpdate(period: Period) {
        //TODO: Fetch data for new period
        print("TrackerFetchDataDisplay")
    }
}

// MARK: - TRPeriodSelectorVCDelegate
extension TrackerVC: TRPeriodSelectorVCDelegate {
    func selectorDidUpdate(period: Period) {
        periodDisplayVC.period = period
        //TODO: Fetch data for new period
        print("TrackerFetchDataSelector")
    }
}
