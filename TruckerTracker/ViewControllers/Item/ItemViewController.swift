//
//  ItemViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/7/23.
//

import UIKit
import CoreLocation

class ItemViewController: UIViewController {

    @IBOutlet var amountTextField: AmountTextField!
    @IBOutlet var segmentedControlView: UIView!
    
    @IBOutlet var tableContainerView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    var amount: Double = 0
    var isNewItem: Bool = true
    
    let segments = ItemType.allCases
    var selectedSegment: ItemType = .load
    var segmentedControl: TRSegmentedControl!
    
    var locationManager: CLLocationManager?
    
    var loadViewModel = LoadViewModel(Load.getDefault())
    
    lazy var loadTableVC: LoadTableViewController = {
        let tableController = LoadTableViewController()
        tableController.delegate = self
        self.addChildTableController(tableController)
        return tableController
    }()
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureTextField()
        configureSegmentedControl()
        configureActionButtons()
        dismissKeyboardOnTouchOutside()
        
        addChildTableController(loadTableVC)
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
    
    // Child VCs
    func addChildTableController(_ tableController: UITableViewController) {
        addChild(tableController)
        tableContainerView.addSubview(tableController.view)
        tableController.view.frame = tableContainerView.bounds
        tableController.didMove(toParent: self)
    }
    
    func removeChildTableController(_ tableController: UITableViewController) {
        tableController.willMove(toParent: nil)
        tableController.view.removeFromSuperview()
        tableController.removeFromParent()
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
        datePickerVC.sheetPresentationController?.largestUndimmedDetentIdentifier = .large
        
        present(datePickerVC, animated: true)
    }
    
    // Location Manager
    func requestUserLocation() {
        if locationManager != nil {
            locationManager?.requestLocation()
        } else {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func displayLocationError(with message: String) {
        if self.isViewLoaded && self.view.window != nil {
            self.showAlert(title: "Location Error", message: message)
        }
    }
    
    // Get City,ST from location
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
        switch selectedSegment {
        case .expense:
            return
        case .load:
            loadTableVC.updateLocation(with: locationInfo)
        case .fuel:
            return
        }
    }
}


// MARK: - LoadTableViewControllerDelegate
extension ItemViewController: LoadTableViewControllerDelegate {
    func didSelectDateCell(_ date: Date) {
        showDatePickerVC(for: date)
    }
    
    func didRequestCurrentLocation() {
        activityIndicator.startAnimating()
        requestUserLocation()
    }
}

// MARK: - DatePickerDelegeate
extension ItemViewController: TRDatePickerVCDelegeate {
    func didSelect(date: Date) {
        switch selectedSegment {
        case .expense:
            return
        case .load:
            loadTableVC.updateDate(date)
        case .fuel:
            return
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension ItemViewController: CLLocationManagerDelegate {
    // Check status
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            return
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.requestLocation()
        case .denied:
            activityIndicator.stopAnimating()
            displayLocationError(with: TRError.permissionLocationError.rawValue)
        default:
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
                    updateViewModelLocation(with: locationInfo)
                    activityIndicator.stopAnimating()
                } catch {
                    activityIndicator.stopAnimating()
                    if let error = error as? TRError {
                        displayLocationError(with: error.rawValue)
                    } else if let error = error as? CLError {
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
        }
    }
    
    // Handle error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
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

