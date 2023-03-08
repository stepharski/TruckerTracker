//
//  ItemViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit

class ItemViewController: UIViewController {

    @IBOutlet var amountTextField: AmountTextField!
    @IBOutlet var segmentedControlView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    var amount: Double = 0
    var isNewItem: Bool = true
    
    let segments = ItemType.allCases
    var selectedSegment: ItemType = .load
    var segmentedControl: TRSegmentedControl!
    
    var loadViewModel = LoadViewModel(Load.getDefault())
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTextField()
        configureSegmentedControl()
        configureTableView()
        configureActionButtons()
        dismissKeyboardOnTouchOutside()
    }
    
    // Navigation Bar
    func configureNavBar() {
        navigationItem.title = isNewItem ? "New Item" : "Edit Item"
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
        amountTextField.containsCurrency = true
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
        
        segmentedControl.titleFontSize = 16
        segmentedControl.titleFontWeight = .medium
        segmentedControl.textColor = .label
        segmentedControl.selectedTextColor = .label
        segmentedControl.selectorColor = .label.withAlphaComponent(0.075)
        segmentedControl.configure(with: titles, type: .capsule, selectedIndex: selectedSegment.index)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentChanged(_ sender: TRSegmentedControl) {
        guard segments.indices.contains(sender.selectedIndex)
            && selectedSegment.index != sender.selectedIndex else { return }
        
        selectedSegment = segments[sender.selectedIndex]
    }
    
    //TableView
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DistanceCell.nib, forCellReuseIdentifier: DistanceCell.identifier)
    }
    
    // Action buttons
    func configureActionButtons() {
        deleteButton.isHidden = isNewItem
        saveButton.dropShadow(opacity: 0.25)
        deleteButton.dropShadow(opacity: 0.25)
    }

}

// MARK: - UITableViewDelegate
extension ItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedSegment {
        case .expense:
            return
            
        case .load:
            let item = loadViewModel.items[indexPath.section]
            
            switch item.type {
            case .tripDistance, .emptyDistance:
                guard let distanceCell = tableView.cellForRow(at: indexPath)
                                                            as? DistanceCell else { return }
                distanceCell.activateTextField()
            default:
                return
            }
            
        case .fuel:
            return
        }
    }
}

// MARK: - UITableViewDataSource
extension ItemViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedSegment {
        case .expense:
            return 0
        case .load:
            return loadViewModel.items.count
        case .fuel:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegment {
        case .expense:
            return 0
        case .load:
            return loadViewModel.items[section].rowCount
        case .fuel:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedSegment {
        case .expense:
            return UITableViewCell()
            
        case .load:
            let item = loadViewModel.items[indexPath.section]
            
            switch item.type {
            case .tripDistance, .emptyDistance:
                let cell = tableView.dequeueReusableCell(withIdentifier: DistanceCell.identifier) as! DistanceCell
                cell.item = item
                return cell
            default:
                return UITableViewCell()
            }
            
        case .fuel:
            return UITableViewCell()
        }
    }
}
