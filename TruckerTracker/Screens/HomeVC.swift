//
//  HomeVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/26/22.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var dateRangePickerView: UIView!
    
    @IBOutlet weak var grossPlaceholderView: UIView!
    @IBOutlet weak var milesPlaceholderView: UIView!
    @IBOutlet weak var expensesPlaceholderView: UIView!
    @IBOutlet weak var fuelPlaceholderView: UIView!
    
    
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
        
        let placeholders = [grossPlaceholderView, milesPlaceholderView,
                            expensesPlaceholderView, fuelPlaceholderView]
        placeholders.forEach { $0?.layer.cornerRadius = 30 }
    }
    
    func applyGradients() {
        dateRangePickerView.applyGradient(colors: [#colorLiteral(red: 0.1529411765, green: 0.3294117647, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1)], locations: [0, 1])
        grossPlaceholderView.applyGradient(colors: [#colorLiteral(red: 0.1921568627, green: 0.6431372549, blue: 0.4549019608, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1450980392, blue: 0.1333333333, alpha: 1)], locations: [0, 1])
        milesPlaceholderView.applyGradient(colors: [#colorLiteral(red: 0.168627451, green: 0.2509803922, blue: 0.2235294118, alpha: 1), #colorLiteral(red: 0, green: 0.06274509804, blue: 0, alpha: 1)], locations: [0, 1])
        expensesPlaceholderView.applyGradient(colors: [#colorLiteral(red: 0.7058823529, green: 0.2745098039, blue: 0.2235294118, alpha: 1), #colorLiteral(red: 0.2509803922, green: 0.0431372549, blue: 0.02352941176, alpha: 1)], locations: [0, 1])
        fuelPlaceholderView.applyGradient(colors: [#colorLiteral(red: 0.4509803922, green: 0.1098039216, blue: 0.07058823529, alpha: 1), #colorLiteral(red: 0.05490196078, green: 0.01176470588, blue: 0.007843137255, alpha: 1)], locations: [0, 1])
    }
    
    
    @objc func openMenu() {
        // TODO: Open MenuVC
    }
    
    @objc func shareReport() {
        // TODO: Share report
    }
}
