//
//  LoadTableViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/22/23.
//

import UIKit

// MARK: - LoadLocationType
enum LoadLocationType {
    case start, end
}

// MARK: - LoadTableViewControllerDelegate
protocol LoadTableViewControllerDelegate: AnyObject {
    func loadDidRequestUserLocation()
    func didSelectLoadDateCell(_ date: Date)
}

// MARK: - LoadTableViewController
class LoadTableViewController: UITableViewController {
    
    var viewModel = LoadViewModel(Load.getDefault())
    weak var delegate: LoadTableViewControllerDelegate?
    private var requestedLocation: LoadLocationType = .start
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    
    // Configuration
    private func configure() {
        view.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        
        tableView.register(LoadDistanceCell.nib, forCellReuseIdentifier: LoadDistanceCell.identifier)
        tableView.register(ItemDateCell.nib, forCellReuseIdentifier: ItemDateCell.identifier)
        tableView.register(LoadLocationCell.nib, forCellReuseIdentifier: LoadLocationCell.identifier)
        tableView.register(DocumentCell.nib, forCellReuseIdentifier: DocumentCell.identifier)
    }
    
    func checkTableIsVisible() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    // MARK: - View Model update
    // Empty distance
    private func updateEmptyDistance(distance: Int) {
        for item in viewModel.items {
            if let emptyDistanceItem = item as? LoadViewModelEmptyDistanceItem {
                emptyDistanceItem.distance = distance
            }
        }
    }
    
    // Trip distance
    private func updateTripDistance(distance: Int) {
        for item in viewModel.items {
            if let tripDistanceItem = item as? LoadViewModelTripDistanceItem {
                tripDistanceItem.distance = distance
            }
        }
    }
    
    // Date
    public func updateDate(_ date: Date) {
        for (index, item) in viewModel.items.enumerated() {
            if let dateItem = item as? LoadViewModelDateItem {
                dateItem.date = date
                tableView.reloadSections(IndexSet(integer: index), with: .none)
            }
        }
    }
    
    // Start location
    private func updateStartLocation(_ location: String) {
        for item in viewModel.items {
            if let startLocationItem = item as? LoadViewModelStartLocationItem {
                startLocationItem.startLocation = location
            }
        }
    }
    
    // End location
    private func updateEndLocation(_ location: String) {
        for item in viewModel.items {
            if let endLocationItem = item as? LoadViewModelEndLocationItem {
                endLocationItem.endLocation = location
            }
        }
    }
    
    // Requested location
    public func updateRequestedLocation(_ locationInfo: String) {
        switch requestedLocation {
        case .start:
            for (index, item) in viewModel.items.enumerated() {
                if let locationItem = item as? LoadViewModelStartLocationItem {
                    locationItem.startLocation = locationInfo
                    tableView.reloadSections(IndexSet(integer: index), with: .none)
                }
            }
        case .end:
            for (index, item) in viewModel.items.enumerated() {
                if let locationItem = item as? LoadViewModelEndLocationItem {
                    locationItem.endLocation = locationInfo
                    tableView.reloadSections(IndexSet(integer: index), with: .none)
                }
            }
        }
    }
    
    //MARK: - Data source
    // Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].rowCount
    }
    
    // Cell for row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.section]
        switch item.type {
        case .emptyDistance, .tripDistance:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadDistanceCell.identifier)
                                                                        as! LoadDistanceCell
            cell.item = item
            
            cell.emptyDistanceDidChange = { [weak self] emptyDistance in
                self?.updateEmptyDistance(distance: emptyDistance)
            }
            
            cell.tripDistanceDidChange = { [weak self] tripDistance in
                self?.updateTripDistance(distance: tripDistance)
            }
            return cell
            
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemDateCell.identifier)
                                                                        as! ItemDateCell
            let dateItem = item as? LoadViewModelDateItem
            cell.date = dateItem?.date
            
            cell.dateDidChange = { [weak self] newDate in
                self?.updateDate(newDate)
            }
            return cell
            
        case .startLocation, .endLocation:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadLocationCell.identifier)
                                                                    as! LoadLocationCell
            cell.item = item
            
            cell.startLocationDidChange = { [weak self] location in
                self?.updateStartLocation(location)
            }
            
            cell.endLocationDidChange = { [weak self] location in
                self?.updateEndLocation(location)
            }
            
            cell.didTapGetCurrentLocation = { [weak self] locationType in
                self?.requestedLocation = locationType
                self?.delegate?.loadDidRequestUserLocation()
            }
            return cell
            
        case .documents:
            let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.identifier)
                                                                        as! DocumentCell
            let documentItem = item as? LoadViewModelDocumentsItem
            cell.documentName = documentItem?.documents[indexPath.row]
            return cell
        }
    }

    //MARK: - Delegate
    // Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.section]
        switch item.type {
        case .tripDistance, .emptyDistance:
            if let distanceCell = tableView.cellForRow(at: indexPath) as? LoadDistanceCell {
                distanceCell.activateTextField()
            }
            
        case .date:
            if let dateItem = item as? LoadViewModelDateItem {
                delegate?.didSelectLoadDateCell(dateItem.date)
            }
            
        case .startLocation, .endLocation:
            if let locationCell = tableView.cellForRow(at: indexPath) as? LoadLocationCell {
                locationCell.activateTextField()
            }
            
        default:
            return
        }
    }
    
    // Header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.items[section].type {
        case .documents:
            return 25
        default:
            return 0
        }
    }
    
    // Row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.items[indexPath.section].type {
        case .startLocation, .endLocation:
            return 65
        default:
            return 55
        }
    }
    
    // Footer height
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch viewModel.items[section].type {
        case .documents:
            return 45
        default:
            return 0
        }
    }
    
    // Header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.items[section].type {
        case .documents:
            let headerView = TRHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
            headerView.titleColor = .dark
            headerView.titleSize = .small
            headerView.title = "Documents"
            return headerView
        default:
            return nil
        }
    }
    
    // Footer view
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch viewModel.items[section].type {
        case .documents:
            let addDocFooter = AddDocumentView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
            addDocFooter.didTapAddButton = {
                //TODO: Add Document
            }
            return addDocFooter
        default:
            return nil
        }
    }
}
