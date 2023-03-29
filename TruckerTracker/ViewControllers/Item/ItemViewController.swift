//
//  ItemViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit
import CoreLocation

class ItemViewController: UIViewController {

    @IBOutlet private var amountTextField: AmountTextField!
    @IBOutlet private var segmentedControlView: UIView!
    
    @IBOutlet private var tableContainerView: UIView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var deleteButton: UIButton!
    
    private var amount: Double = 0
    private var isNewItem: Bool = true
    
    private var locationManager = LocationManager.shared
    
    private var segmentedControl: TRSegmentedControl!
    private let segments = ItemType.allCases
    var selectedSegment: ItemType = .load {
        didSet { stopLocationUpdates()
                    updateSegmentVC() }
    }
    
    var expense: Expense? {
        didSet {
            if let expense = expense {
                amount = expense.amount
                expenseTableVC.viewModel = ExpenseViewModel(expense)
            }
        }
    }
    
    var load: Load? {
        didSet {
            if let load = load {
                amount = load.amount
                loadTableVC.viewModel = LoadViewModel(load)
            }
        }
    }
    
    var fueling: Fuel? {
        didSet {
            if let fueling = fueling {
                amount = fueling.totalAmount
                fuelTableVC.viewModel = FuelViewModel(fueling)
            }
        }
    }
    
    lazy private var expenseTableVC: ExpenseTableViewController = {
        let tableController = ExpenseTableViewController()
        tableController.delegate = self
        return tableController
    }()
    
    lazy private var loadTableVC: LoadTableViewController = {
        let tableController = LoadTableViewController()
        tableController.delegate = self
        return tableController
    }()
    
    lazy private var fuelTableVC: FuelTableViewController = {
        let tableController = FuelTableViewController()
        tableController.delegate = self
        return tableController
    }()
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkItemModels()
        
        configureNavBar()
        configureTextField()
        configureActionButtons()
        configureSegmentedControl()

        addSwipeGestures()
        dismissKeyboardOnTouchOutside()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLocationUpdates()
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
        amountTextField.amount = amount.formattedString
        amountTextField.amountDidChange = { [weak self] amount in
            self?.amount = amount
            
            if let isFuelTableVisible = self?.fuelTableVC.isViewVisible, isFuelTableVisible {
                self?.fuelTableVC.updateFuelAmounts(with: amount)
            }
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
    
    func updateSegmentVC() {
        switch selectedSegment {
        case .expense:
            removeChildTableController(loadTableVC)
            removeChildTableController(fuelTableVC)
            addChildTableController(expenseTableVC)
        case .load:
            removeChildTableController(expenseTableVC)
            removeChildTableController(fuelTableVC)
            addChildTableController(loadTableVC)
        case .fuel:
            removeChildTableController(expenseTableVC)
            removeChildTableController(loadTableVC)
            addChildTableController(fuelTableVC)
            
            if fuelTableVC.totalAmount != amount {
                fuelTableVC.updateFuelAmounts(with: amount)
            }
        }
    }
    
    // Models
    func checkItemModels() {
        isNewItem = false
        if expense != nil {
            selectedSegment = .expense
            
        } else if load != nil {
            selectedSegment = .load
            
        } else if fueling != nil {
            selectedSegment = .fuel
            
        } else {
            isNewItem = true
            load = Load.getEmpty()
            selectedSegment = .load
        }
    }
    
    // Child VCs
    func addChildTableController(_ tableController: UITableViewController) {
        guard tableController.parent == nil else { return }
        
        addChild(tableController)
        tableContainerView.addSubview(tableController.view)
        tableController.view.frame = tableContainerView.bounds
        tableController.didMove(toParent: self)
    }
    
    func removeChildTableController(_ tableController: UITableViewController) {
        guard tableController.parent != nil else { return }
        
        tableController.willMove(toParent: nil)
        tableController.view.removeFromSuperview()
        tableController.removeFromParent()
    }

    // Gestures
    func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        swipeRight.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        var currentSegment = selectedSegment.index
        
        if sender.direction == .left && currentSegment < (segments.count - 1) {
            currentSegment += 1
            selectedSegment = segments[currentSegment]
            segmentedControl.selectSegment(at: currentSegment)
            
        } else if sender.direction == .right && currentSegment > 0 {
            currentSegment -= 1
            selectedSegment = segments[currentSegment]
            segmentedControl.selectSegment(at: currentSegment)
        }
    }
    
    // Action buttons
    func configureActionButtons() {
        deleteButton.isHidden = isNewItem
        saveButton.dropShadow(opacity: 0.25)
        deleteButton.dropShadow(opacity: 0.25)
    }

    // Navigation
    func showDatePickerVC(for date: Date) {
        let datePickerVC = TRDatePickerVC()
        datePickerVC.delegate = self
        datePickerVC.pickerDate = date
        datePickerVC.modalPresentationStyle = .pageSheet
        datePickerVC.sheetPresentationController?.detents = [.medium()]
        
        present(datePickerVC, animated: true)
    }
    
    func showFrequencyPickerVC(for frequency: FrequencyType) {
        var pickerItems = [String]()
        FrequencyType.allCases.forEach { pickerItems.append($0.title) }
        
        let pickerVC = TRPickerVC(pickerItems: pickerItems, selectedRow: frequency.index ?? 0)
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .pageSheet
        pickerVC.sheetPresentationController?.detents = [.medium()]

        present(pickerVC, animated: true)
    }
    
    // Location
    func requestUserLocation() {
        activityIndicator.startAnimating()
        
        locationManager.didReceiveLocationInfo = { [weak self] location in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.updateViewModelLocation(with: location)
            }

        }
        
        locationManager.didFailToReceiveLocation = { [weak self] error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.displayLocationError(with: error.rawValue)
            }
        }
        
        locationManager.requestUserLocation()
    }
    
    func stopLocationUpdates() {
        guard locationManager.locationRequestState == .requestingLocation else { return }
        locationManager.locationRequestState = .canceled
        locationManager.didFailToReceiveLocation = nil
        locationManager.didReceiveLocationInfo = nil
        activityIndicator.stopAnimating()
    }
    
    func displayLocationError(with message: String) {
        if self.isViewVisible {
            self.showAlert(title: "Location Error", message: message)
        }
    }
    
    // Update VM location
    func updateViewModelLocation(with locationInfo: String) {
        guard self.isViewVisible else { return }
        
        switch selectedSegment {
        case .expense:
            return
        case .load:
            loadTableVC.updateRequestedLocation(locationInfo)
        case .fuel:
            fuelTableVC.updateRequestedLocation(locationInfo)
        }
    }
}


// MARK: - ExpenseTableViewControllerDelegate
extension ItemViewController: ExpenseTableViewControllerDelegate {
    func didSelectExpenseDateCell(_ date: Date) {
        showDatePickerVC(for: date)
    }
    
    func didSelectExpenseFrequencyCell(_ frequency: FrequencyType) {
        showFrequencyPickerVC(for: frequency)
    }
}

// MARK: - LoadTableViewControllerDelegate
extension ItemViewController: LoadTableViewControllerDelegate {
    func didSelectLoadDateCell(_ date: Date) {
        showDatePickerVC(for: date)
    }
    
    func loadDidRequestUserLocation() {
        requestUserLocation()
    }
}

// MARK: - FuelTableViewControllerDelegate
extension ItemViewController: FuelTableViewControllerDelegate {
    func didUpdateFuelAmount(_ amount: Double) {
        self.amount = amount
        self.amountTextField.amount = amount.formattedString
    }
    
    func fuelDidRequestUserLocation() {
        requestUserLocation()
    }
    
    func didSelectFuelDateCell(_ date: Date) {
        showDatePickerVC(for: date)
    }
}

// MARK: - DatePickerDelegeate
extension ItemViewController: TRDatePickerVCDelegeate {
    func didSelect(date: Date) {
        switch selectedSegment {
        case .expense:
            expenseTableVC.updateDate(date)
        case .load:
            loadTableVC.updateDate(date)
        case .fuel:
            fuelTableVC.updateDate(date)
        }
    }
}

// MARK: - TRPickerDelegate
extension ItemViewController: TRPickerDelegate {
    func didSelectRow(_ row: Int) {
        guard FrequencyType.allCases.count > row, expenseTableVC.parent != nil else { return }
        
        let selectedFrequency = FrequencyType.allCases[row]
        expenseTableVC.updateFrequency(selectedFrequency)
    }
}
