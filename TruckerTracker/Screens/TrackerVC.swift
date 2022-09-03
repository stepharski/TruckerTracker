//
//  TrackerVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 9/3/22.
//

import UIKit

enum TrackerCategory: String {
    case gross, miles, expenses, fuel
    
    var image: UIImage? {
        switch self {
        case .gross:
            return SFSymbols.dollar
        case .miles:
            return SFSymbols.doubleCircle
        case .expenses:
            return SFSymbols.minusCircle
        case .fuel:
            return SFSymbols.flame
        }
    }
    
    var gradientColors: [UIColor] {
        switch self {
        case .gross:
            return [#colorLiteral(red: 0.1921568627, green: 0.6431372549, blue: 0.4549019608, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1450980392, blue: 0.1333333333, alpha: 1)]
        case .miles:
            return [#colorLiteral(red: 0.168627451, green: 0.2509803922, blue: 0.2235294118, alpha: 1), #colorLiteral(red: 0, green: 0.06274509804, blue: 0, alpha: 1)]
        case .expenses:
            return [#colorLiteral(red: 0.7058823529, green: 0.2745098039, blue: 0.2235294118, alpha: 1), #colorLiteral(red: 0.2509803922, green: 0.0431372549, blue: 0.02352941176, alpha: 1)]
        case .fuel:
            return [#colorLiteral(red: 0.4509803922, green: 0.1098039216, blue: 0.07058823529, alpha: 1), #colorLiteral(red: 0.05490196078, green: 0.01176470588, blue: 0.007843137255, alpha: 1)]
        }
    }
    
    var gradientLocations: [NSNumber] {
        return [0, 1]
    }
    
    var title: String {
        return self.rawValue.capitalized(with: nil)
    }
}

class TrackerVC: UIViewController {

    @IBOutlet weak var dateRangePickerView: UIView!
    
    @IBOutlet weak var grossCategoryView: UIView!
    @IBOutlet weak var milesCategoryView: UIView!
    @IBOutlet weak var expensesCategoryView: UIView!
    @IBOutlet weak var fuelCategoryView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureUI()
        bindTapGestureToCategories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        applyGradients()
    }
    
    
    func configureNavBar() {
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
        
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    func configureUI() {
        dateRangePickerView.layer.cornerRadius = 30
        
        let categoryViews = [grossCategoryView, milesCategoryView,
                            expensesCategoryView, fuelCategoryView]
        categoryViews.forEach { $0?.layer.cornerRadius = 30 }
    }
    
    func applyGradients() {
        dateRangePickerView.applyGradient(colors: [#colorLiteral(red: 0.1529411765, green: 0.3294117647, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)], locations: [0, 1])
        
        grossCategoryView.applyGradient(colors: TrackerCategory.gross.gradientColors,
                                        locations: TrackerCategory.gross.gradientLocations)
        milesCategoryView.applyGradient(colors: TrackerCategory.miles.gradientColors,
                                        locations: TrackerCategory.miles.gradientLocations)
        expensesCategoryView.applyGradient(colors: TrackerCategory.expenses.gradientColors,
                                           locations: TrackerCategory.expenses.gradientLocations)
        fuelCategoryView.applyGradient(colors: TrackerCategory.fuel.gradientColors,
                                       locations: TrackerCategory.fuel.gradientLocations)
    }
    
    
    func bindTapGestureToCategories() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCategory(_:)))
        grossCategoryView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapCategory(_ sender: UITapGestureRecognizer) {
        presentTrackerCategoryVC()
    }
    
    @objc func presentTrackerCategoryVC() {
        let trackerCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.trackerCategoryVC) as! TrackerCategoryVC
        self.present(trackerCategoryVC, animated: true)
    }
    
    @objc func openMenu() {
        // TODO: Open MenuVC
    }
    
    @objc func shareReport() {
        // TODO: Share report
    }
}
