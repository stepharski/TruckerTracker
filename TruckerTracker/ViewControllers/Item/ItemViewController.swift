//
//  ItemViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit
import CoreLocation

//MARK: - LocationRequestState
enum LocationRequestState {
    case notStarted
    case requestingLocation
    case locationFound
    case timedOut
    case error
}

// MARK: - ItemViewController
class ItemViewController: UIViewController {

    @IBOutlet var amountTextField: AmountTextField!
    @IBOutlet var segmentedControlView: UIView!
    
    @IBOutlet var tableContainerView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    var amount: Double = 0
    var isNewItem: Bool = true
    
    var segmentedControl: TRSegmentedControl!
    let segments = ItemType.allCases
    var selectedSegment: ItemType = .expense {
        didSet { stopLocationUpdates()
                    updateSegmentVC() }
    }
    
    var locationManager: CLLocationManager?
    let loactionTimeout: Double = 10
    var locationRequestState: LocationRequestState = .notStarted
    
    lazy var expenseTableVC: ExpenseTableViewController = {
        let tableController = ExpenseTableViewController()
        tableController.delegate = self
        return tableController
    }()
    
    lazy var loadTableVC: LoadTableViewController = {
        let tableController = LoadTableViewController()
        tableController.delegate = self
        return tableController
    }()
    
    lazy var fuelTableVC: FuelTableViewController = {
        let tableController = FuelTableViewController()
        return tableController
    }()
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTextField()
        updateSegmentVC()
        addSwipeGestures()
        configureSegmentedControl()
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
    
    // Location Manager
    func requestUserLocation() {
        if locationManager != nil {
            locationRequestState = .requestingLocation
            locationManager?.requestLocation()
            checkForLocationTimeout()
        } else {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func checkForLocationTimeout() {
        Timer.scheduledTimer(withTimeInterval: loactionTimeout, repeats: false) { _ in
            if self.locationRequestState == .requestingLocation {
                self.locationRequestState = .timedOut
                self.activityIndicator.stopAnimating()
                self.displayLocationError(with: TRError.timeoutError.rawValue)
            }
        }
    }
    
    func stopLocationUpdates() {
        // TODO: Handle case Load -> Fuel
        if locationRequestState == .requestingLocation {
            locationRequestState = .notStarted
            activityIndicator.stopAnimating()
        }
    }
    
    func displayLocationError(with message: String) {
        if self.isViewVisible {
            self.showAlert(title: "Location Error", message: message)
        }
    }
    
    // Location info
    func getLocationInfo(from location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        guard let placemark = placemarks.first else {
            throw TRError.defaultLocationError
        }
        
        let city = placemark.locality ?? "Nowhereville"
        let state = placemark.administrativeArea ?? "NA"
        
        return "\(city), \(state)"
    }
    
    // Update VM location
    func updateViewModelLocation(with locationInfo: String) {
        // TODO: - Handle case Load -> Fuel
        guard self.isViewVisible else { return }
        
        switch selectedSegment {
        case .expense:
            return
        case .load:
            loadTableVC.updateRequestedLocation(locationInfo)
        case .fuel:
            return
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
        activityIndicator.startAnimating()
        requestUserLocation()
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
            return
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

// MARK: - CLLocationManagerDelegate
extension ItemViewController: CLLocationManagerDelegate {
    // Check status
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationRequestState = .notStarted
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationRequestState = .requestingLocation
            locationManager?.requestLocation()
            checkForLocationTimeout()
            
        case .denied:
            locationRequestState = .error
            activityIndicator.stopAnimating()
            displayLocationError(with: TRError.permissionLocationError.rawValue)
            
        default:
            locationRequestState = .error
            activityIndicator.stopAnimating()
            displayLocationError(with: TRError.defaultLocationError.rawValue)
        }
    }
    
    // Handle location info
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let clLocation = CLLocation(latitude: latitude, longitude: longitude)
            
            Task {
                do {
                    let locationInfo = try await getLocationInfo(from: clLocation)
                    
                    guard locationRequestState != .timedOut else { return }
                    updateViewModelLocation(with: locationInfo)
                    locationRequestState = .locationFound
                } catch {
                    guard locationRequestState != .timedOut else { return }
                    locationRequestState = .error
                    
                    if let error = error as? TRError {
                        displayLocationError(with: error.rawValue)
                    } else if let error = error as? CLError, error.code == .network {
                        displayLocationError(with: TRError.networkError.rawValue)
                    } else {
                        displayLocationError(with: TRError.defaultLocationError.rawValue)
                    }
                }
                
                activityIndicator.stopAnimating()
            }
        }
    }
    
    // Handle error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard locationRequestState != .timedOut else { return }
        
        locationRequestState = .error
        activityIndicator.stopAnimating()
        
        if let error = error as? CLError {
            switch error.code {
            case .network:
                displayLocationError(with: TRError.networkError.rawValue)
            case .denied:
                displayLocationError(with: TRError.permissionLocationError.rawValue)
            default:
                displayLocationError(with: TRError.defaultLocationError.rawValue)
            }
        }
    }
}

