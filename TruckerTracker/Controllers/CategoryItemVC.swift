//
//  CategoryItemVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 10/12/22.
//

import UIKit

class CategoryItemVC: UIViewController {
    
    var currentCategory: TrackerCategoryType = .gross {
        didSet {
            updateUI()
        }
    }
    
    
    @IBOutlet weak var selectedCategoryImageView: UIImageView!
    @IBOutlet var categoryButtons: [UIButton]!
    
    @IBOutlet weak var tableBackgoundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBAction func didTapCategoryButton(_ sender: UIButton) {
        guard let index = categoryButtons.firstIndex(of: sender) else { return }
        
        categoryButtons.forEach { $0.isSelected = $0 == sender }
        currentCategory = TrackerCategoryType.allCases[index]
    }
    
    
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
        navigationItem.title = "New Item"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbols.xmark,
            style: .plain,
            target: self,
            action: #selector(dismissVC))
    }
    
    func configureUI() {
        deleteButton.isHidden = true
        tableBackgoundView.layer.cornerRadius = 30
    }
    
    func updateUI() {
        UIView.animate(withDuration: 0.25) {
            self.selectedCategoryImageView.image = self.currentCategory.image
            self.selectedCategoryImageView.tintColor = self.currentCategory.imageTintColor
            
            self.view.backgroundColor = self.currentCategory == .gross
                                  || self.currentCategory == .miles ? #colorLiteral(red: 0.03529411765, green: 0.09019607843, blue: 0.06666666667, alpha: 1) : #colorLiteral(red: 0.1176470588, green: 0.03137254902, blue: 0.02352941176, alpha: 1)
        }
    }
    
    func applyGradients() {
        if let gradientLayer = (tableBackgoundView.layer.sublayers?.compactMap{ $0 as? CAGradientLayer })?.first {
            gradientLayer.removeFromSuperlayer()
        }
        
        let startGradientColor = self.currentCategory == .gross
                              || self.currentCategory == .miles ? #colorLiteral(red: 0.137254902, green: 0.1921568627, blue: 0.1764705882, alpha: 1) : #colorLiteral(red: 0.2431372549, green: 0.08235294118, blue: 0.06666666667, alpha: 1)
        self.tableBackgoundView.applyGradient(colors: [startGradientColor, .black], locations: [0, 1])
    }
        

    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
}
