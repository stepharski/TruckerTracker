//
//  TrackerVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 9/3/22.
//

import UIKit

class TrackerVC: UIViewController {

    @IBOutlet weak var totalValueTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalValueBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dateRangePickerView: UIView!
    @IBOutlet var categoryBackgroundViews: [UIView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureUI()
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbols.menu,
            style: .plain,
            target: self,
            action: #selector(openMenu))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: SFSymbols.share,
            style: .plain,
            target: self,
            action: #selector(shareReport))
    }

    
    func configureUI() {
        dateRangePickerView.roundEdges()
        categoryBackgroundViews.forEach { $0.roundEdges() }
        
        totalValueTopConstraint.constant = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhoneZoomed ? 20 : 40
        totalValueBottomConstraint.constant = totalValueTopConstraint.constant
    }
    
    
    func configureCategoryViews() {
        guard categoryBackgroundViews.count == TrackerCategoryType.allCases.count else {
            return
        }
        
        for index in categoryBackgroundViews.indices {
            let categoryType = TrackerCategoryType.allCases[index]
            let categoryInfoView = CategoryInfoView(categoryType: categoryType, withCount: 8800)
            let categoryBackgroundView = categoryBackgroundViews[index]
            categoryBackgroundView.addSubview(categoryInfoView)
            
            categoryInfoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                categoryInfoView.centerXAnchor.constraint(equalTo: categoryBackgroundView.centerXAnchor),
                categoryInfoView.centerYAnchor.constraint(equalTo: categoryBackgroundView.centerYAnchor)
            ])
        }
    }
    
    
    func applyGradients() {
        dateRangePickerView.applyGradient(colors: [#colorLiteral(red: 0.1529411765, green: 0.3294117647, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)], locations: [0, 1])
        
        guard categoryBackgroundViews.count == TrackerCategoryType.allCases.count else {
            return
        }
        
        for index in categoryBackgroundViews.indices {
            let categoryType = TrackerCategoryType.allCases[index]
            categoryBackgroundViews[index].applyGradient(colors: categoryType.gradientColors,
                                                         locations: categoryType.gradientLocations)
        }
    }
    
    
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
    
    
    @objc func openMenu() {
        // TODO: Open MenuVC
    }
    
    @objc func shareReport() {
        // TODO: Share report
    }
}
