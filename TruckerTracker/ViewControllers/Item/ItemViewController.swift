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
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    var amount: Double = 0
    var isNewItem: Bool = true
    
    let segments = ItemType.allCases
    var selectedSegment: ItemType = .load
    var segmentedControl: TRSegmentedControl!
    
    var locationManager: CLLocationManager?
    var locationType: LocationType = .loadStart
    
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
        tableView.register(DateCell.nib, forCellReuseIdentifier: DateCell.identifier)
        tableView.register(LoadLocationCell.nib, forCellReuseIdentifier: LoadLocationCell.identifier)
        tableView.register(DocumentCell.nib, forCellReuseIdentifier: DocumentCell.identifier)
    }
    
    func createSectionHeader(with title: String) -> TRHeaderView {
        let headerView = TRHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width,
                                                            height: 35))
        headerView.title = title
        headerView.titleColor = .fadedWhite
        return headerView
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
        var locationSectionIndex = 0
        
        switch locationType {
        case .loadStart:
            for (index, item) in loadViewModel.items.enumerated() {
                if let locationItem = item as? LoadViewModelStartLocationItem {
                    locationItem.startLocation = locationInfo
                    locationSectionIndex = index
                }
            }
        case .loadEnd:
            for (index, item) in loadViewModel.items.enumerated() {
                if let locationItem = item as? LoadViewModelEndLocationItem {
                    locationItem.endLocation = locationInfo
                    locationSectionIndex = index
                }
            }
        case .fuel:
            //TODO: Update FuelVM
            return
        }
        
        tableView.reloadSections(IndexSet(integer: locationSectionIndex), with: .automatic)
    }
}


// MARK: CLLocationManagerDelegate
extension ItemViewController: CLLocationManagerDelegate {
    // Check status
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            return
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.requestLocation()
        case .denied:
            displayLocationError(with: TRError.permissionLocationError.rawValue)
        default:
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
            
            activityIndicator.startAnimating()
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

// MARK: - TRDatePickerVCDelegeate
extension ItemViewController: TRDatePickerVCDelegeate {
    func didSelect(date: Date) {
        var dateSectionIndex = 0
        
        switch selectedSegment {
        case .expense:
            return
        case .load:
            for (index, item) in loadViewModel.items.enumerated() {
                if let dateItem = item as? LoadViewModelDateItem {
                    dateItem.date = date
                    dateSectionIndex = index
                }
            }
        case .fuel:
            return
        }
        
        tableView.reloadSections(IndexSet(integer: dateSectionIndex), with: .automatic)
    }
}


// MARK: - UITableViewDelegate
extension ItemViewController: UITableViewDelegate {
    // Header
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch selectedSegment {
//        case .expense:
//            return nil
//
//        case .load:
//            let item = loadViewModel.items[section]
//            switch item.type {
//            case .documents:
//                return createSectionHeader(with: "Documents")
//            default:
//                return nil
//            }
//
//        case .fuel:
//            return nil
//        }
//    }
    
    
    // Height for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedSegment {
        case .expense:
            return 0
            
        case .load:
            let item = loadViewModel.items[indexPath.section]
            switch item.type {
            case .startLocation, .endLocation:
                return 65
            default:
                return 50
            }
            
        case .fuel:
            return 0
        }
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedSegment {
        case .expense:
            return
            
        case .load:
            let item = loadViewModel.items[indexPath.section]
            switch item.type {
                
            case .tripDistance, .emptyDistance:
                if let distanceCell = tableView.cellForRow(at: indexPath) as? DistanceCell {
                    distanceCell.activateTextField()
                }
                
            case .date:
                if let dateItem = item as? LoadViewModelDateItem {
                    showDatePickerVC(for: dateItem.date)
                }
                
            case .startLocation, .endLocation:
                if let locationCell = tableView.cellForRow(at: indexPath)
                                                    as? LoadLocationCell {
                    locationCell.activateTextField()
                }
                
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
    // Number of sections
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
    
    // Number of rows
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
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedSegment {
        case .expense:
            return UITableViewCell()
            
        case .load:
            let item = loadViewModel.items[indexPath.section]
            
            switch item.type {
            case .tripDistance, .emptyDistance:
                let cell = tableView.dequeueReusableCell(withIdentifier: DistanceCell.identifier)
                                                                            as! DistanceCell
                cell.item = item
                return cell
                
            case .date:
                let cell = tableView.dequeueReusableCell(withIdentifier: DateCell.identifier)
                                                                            as! DateCell
                cell.item = item
                return cell
                
            case .startLocation, .endLocation:
                let cell = tableView.dequeueReusableCell(withIdentifier: LoadLocationCell.identifier)
                                                                        as! LoadLocationCell
                cell.item = item
                cell.didTapGetCurrentLocation = { locationType in
                    self.locationType = locationType
                    self.requestUserLocation()
                }
                return cell
                
            case .documents:
                let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.identifier)
                                                                            as! DocumentCell
                let documentItem = item as? LoadViewModelDocumentsItem
                cell.documentName = documentItem?.documents[indexPath.row]
                return cell
            }
            
        case .fuel:
            return UITableViewCell()
        }
    }
}
