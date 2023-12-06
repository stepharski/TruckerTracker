//
//  ItemEntryViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit
import CoreLocation

class ItemEntryViewController: UIViewController {

    private var savingOverlayView: UIView?
    private lazy var spinner: UIActivityIndicatorView = createSpinner()
    
    @IBOutlet private var amountTextField: AmountTextField!
    @IBOutlet private var segmentedControlView: UIView!
    @IBOutlet private var tableContainerView: UIView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var deleteButton: UIButton!
    @IBOutlet private var actionButtonsBottomConstraint: NSLayoutConstraint!
    
    lazy private var expenseTableVC: ExpenseTableViewController = {
        let tableController = ExpenseTableViewController()
        tableController.viewModel = viewModel.getExpenseTableVM()
        tableController.delegate = self
        return tableController
    }()
    
    lazy private var loadTableVC: LoadTableViewController = {
        let loadTableVM = viewModel.getLoadTableVM()
        let tableController = LoadTableViewController(viewModel: loadTableVM)
        tableController.delegate = self
        return tableController
    }()
    
    lazy private var fuelTableVC: FuelTableViewController = {
        let tableController = FuelTableViewController()
        tableController.viewModel = viewModel.getFuelTableVM()
        tableController.delegate = self
        return tableController
    }()
    
    private var viewModel = ItemEntryViewModel()
    private var locationManager = LocationManager()
    private var segmentedControl: TRSegmentedControl!
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinders()
        addSwipeGestures()
        configureNavBar()
        configureTextField()
        configureActionButtons()
        configureSegmentedControl()
        dismissKeyboardOnTouchOutside()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.isNewItem { amountTextField.activate() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopLocationUpdates()
    }
    
    
    // View Model
    func setupViewModel(with model: ItemModel) {
        self.viewModel = ItemEntryViewModel(model: model)
    }
    
    private func setupBinders() {
        setupSegmentBinder()
        setupFuelAmountBinder()
        setupLocationBinder()
        setupResultBinder()
    }
    
    // VM Binders
    private func setupSegmentBinder() {
        viewModel.selectedSegment.bind { [weak self] _ in
            self?.updateTableVC()
        }
    }
    
    private func setupFuelAmountBinder() {
        fuelTableVC.viewModel.totalFuelAmount.bind { [weak self] fuelAmount in
            guard let self = self else { return }
            guard fuelAmount != viewModel.amount else { return }
            
            viewModel.updateItemAmount(fuelAmount)
            self.amountTextField.amount = fuelAmount.formattedString
        }
    }
    
    private func setupLocationBinder() {
        viewModel.locationState.bind { [weak self] locationState in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch locationState {
                case .requesting:
                    self.activityIndicator.startAnimating()
                case .idle, .received:
                    self.activityIndicator.stopAnimating()
                case .error(let error):
                    self.activityIndicator.stopAnimating()
                    self.showAlert(title: "Location Error", message: error.rawValue)
                }
            }
        }
    }
    
    private func setupResultBinder() {
        viewModel.dataOperationResult.bind { [weak self] result in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.dismissSavingOverlay()
            switch result {
            case .success():
                NotificationCenter.default.post(name: .itemDataChanged, object: nil,
                                            userInfo: ["date": viewModel.itemDate]) // Consider deletion date
                self.dismissVC()
            case .failure(let error):
                if let error = error as? ValidationError {
                    self.showAlert(title: "Validation Error", message: error.rawValue)
                } else {
                    self.showAlert(title: "Data Operation Error", message: error.localizedDescription)
                }
            case .none: break
            }
        }
    }
    
    // @IBActions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        activityIndicator.startAnimating()
        showSavingOverlay()
        viewModel.saveIfValid()
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        activityIndicator.startAnimating()
        showSavingOverlay()
        viewModel.deleteInitialItem()
    }
    
    // Navigation Bar
    private func configureNavBar() {
        navigationItem.title = viewModel.isNewItem ? "New Item" : "Edit Item"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: SFSymbols.xmark,
            style: .plain,
            target: self,
            action: #selector(dismissVC))
    }
    
    @objc private func dismissVC() {
        self.dismiss(animated: true)
    }
    
    // Amount TextField
    private func configureTextField() {
        amountTextField.containsCurrency = true
        amountTextField.amount = viewModel.amount.formattedString
        amountTextField.amountDidChange = { [weak self] amount in
            self?.viewModel.updateItemAmount(amount)
        }
    }
    
    // Segmented control
    private func configureSegmentedControl() {
        segmentedControl = TRSegmentedControl(frame: segmentedControlView.bounds)
        segmentedControl.backgroundColor = .systemGray6
        segmentedControlView.addSubview(segmentedControl)
        segmentedControl.pinToEdges(of: segmentedControlView)
        
        segmentedControl.titleFontSize = 16
        segmentedControl.titleFontWeight = .medium
        segmentedControl.textColor = .label
        segmentedControl.selectedTextColor = .label
        segmentedControl.selectorColor = .label.withAlphaComponent(0.075)
        
        segmentedControl.configure(with: viewModel.segmentTitles, type: .capsule,
                                   selectedIndex: viewModel.selectedSegment.value)
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc private func segmentChanged(_ sender: TRSegmentedControl) {
        viewModel.selectSegment(sender.selectedIndex)
    }
    
    // Gestures
    private func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        swipeLeft.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        swipeRight.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        var currentSegment = viewModel.selectedSegment.value

        if sender.direction == .left && currentSegment < (viewModel.segments.count - 1) {
            currentSegment += 1
            viewModel.selectSegment(currentSegment)
            segmentedControl.selectSegment(currentSegment)

        } else if sender.direction == .right && currentSegment > 0 {
            currentSegment -= 1
            viewModel.selectSegment(currentSegment)
            segmentedControl.selectSegment(currentSegment)
        }
    }
    
    // Table Controllers
    private func updateTableVC() {
        switch viewModel.selectedSegmentType {
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
            viewModel.updateFuelTableAmountsIfNeeded()
        }
    }
    
    private func addChildTableController(_ tableController: UITableViewController) {
        guard tableController.parent == nil else { return }
        
        addChild(tableController)
        tableContainerView.addSubview(tableController.view)
        tableController.view.frame = tableContainerView.bounds
        tableController.didMove(toParent: self)
    }
    
    private func removeChildTableController(_ tableController: UITableViewController) {
        guard tableController.parent != nil else { return }
        
        tableController.willMove(toParent: nil)
        tableController.view.removeFromSuperview()
        tableController.removeFromParent()
    }

    // Action buttons
    private func configureActionButtons() {
        deleteButton.isHidden = viewModel.isNewItem
        actionButtonsBottomConstraint.constant = DeviceTypes.isiPhoneSE ? 20 : 0
    }

    // Navigation
    private func showDatePickerVC(for date: Date) {
        let datePickerVC = DatePickerViewController()
        datePickerVC.delegate = self
        datePickerVC.pickerDate = date
        datePickerVC.modalPresentationStyle = .pageSheet
        datePickerVC.sheetPresentationController?.detents = [.medium()]
        
        present(datePickerVC, animated: true)
    }
    
    private func showFrequencyPickerVC(for frequency: FrequencyType) {
        let pickerItems = FrequencyType.allCases.map { $0.title }
        let pickerVC = OptionPickerViewController(pickerItems: pickerItems,
                                               selectedRow: frequency.index ?? 0)
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .pageSheet
        pickerVC.sheetPresentationController?.detents = [.medium()]
        present(pickerVC, animated: true)
    }
    
    // Spinner
    private func createSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = .systemGreen
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: parent?.view.centerXAnchor ?? view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: parent?.view.centerYAnchor ?? view.centerYAnchor)
        ])
        
        return spinner
    }
    
    // Saving overlay
    func showSavingOverlay() {
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.pinToEdges(of: view)
        self.savingOverlayView = overlayView
    }
    
    func dismissSavingOverlay() {
        self.savingOverlayView?.removeFromSuperview()
        self.savingOverlayView = nil
    }
}


// MARK: - ExpenseTableViewController Delegate
extension ItemEntryViewController: ExpenseTableViewControllerDelegate {
    func didSelectExpenseDateCell(_ date: Date) {
        showDatePickerVC(for: date)
    }
    
    func didSelectExpenseFrequencyCell(_ frequency: FrequencyType) {
        showFrequencyPickerVC(for: frequency)
    }
}

// MARK: - LoadTableViewController Delegate
extension ItemEntryViewController: LoadTableViewControllerDelegate {
    func didSelectLoadDateCell(_ date: Date) {
        showDatePickerVC(for: date)
    }
    
    func loadDidRequestUserLocation() {
        viewModel.requestUserLocation()
    }
}

// MARK: - FuelTableViewControllerDelegate
extension ItemEntryViewController: FuelTableViewControllerDelegate {
    func fuelDidRequestUserLocation() {
        viewModel.requestUserLocation()
    }
    
    func didSelectFuelDateCell(_ date: Date) {
        showDatePickerVC(for: date)
    }
}

// MARK: - DatePicker Delegeate
extension ItemEntryViewController: DatePickerDelegeate {
    func didSelect(date: Date) {
        viewModel.updateItemDate(date)
    }
}

// MARK: - TRPickerDelegate
extension ItemEntryViewController: OptionPickerDelegate {
    func didSelectRow(_ row: Int) {
        viewModel.updateItemFrequency(FrequencyType.allCases[safe: row])
    }
}
