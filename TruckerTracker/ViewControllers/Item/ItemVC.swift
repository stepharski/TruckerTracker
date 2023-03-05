//
//  ItemVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 2/18/23.
//

import UIKit

class ItemVC: UIViewController {

    @IBOutlet var amountTextField: CurrencyTextField!
    @IBOutlet var segmentedControlView: UIView!
    
    var amount: Double = 0
    var segmentedControl: TRSegmentedControl!
    
    let segments = ItemType.allCases
    var selectedSegment: ItemType = .load
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTextField()
        configureSegmentedControl()
    }
    
    // Navigation Bar
    func configureNavBar() {
        navigationItem.title = "New Item"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: SFSymbols.xmark,
            style: .plain,
            target: self,
            action: #selector(dismissVC))
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true)
    }
    
    // Amount TextField
    func configureTextField() {
        amountTextField.amountDidChange = { amount in
            self.amount = amount
        }
    }
    
    // Segmented control
    func configureSegmentedControl() {
        var titles = [String]()
        segments.forEach { titles.append($0.title.capitalized) }
        
        segmentedControl = TRSegmentedControl(frame: segmentedControlView.bounds)
        segmentedControl.backgroundColor = .systemGray6
        segmentedControlView.addSubview(segmentedControl)
        segmentedControl.pinToEdges(of: segmentedControlView)
        
        segmentedControl.titleFontSize = 17
        segmentedControl.titleFontWeight = .medium
        segmentedControl.textColor = .label
        segmentedControl.selectedTextColor = .label
        segmentedControl.selectorColor = .label.withAlphaComponent(0.1)
        segmentedControl.configure(with: titles, type: .capsule, selectedIndex: selectedSegment.index)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentChanged(_ sender: TRSegmentedControl) {
        guard segments.indices.contains(sender.selectedIndex)
            && selectedSegment.index != sender.selectedIndex else { return }
        
        selectedSegment = segments[sender.selectedIndex]
    }
}
