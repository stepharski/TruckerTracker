//
//  FuelTableViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/23/23.
//

import UIKit

// MARK: - FuelTableViewControllerDelegate
protocol FuelTableViewControllerDelegate: AnyObject {
    func fuelDidRequestUserLocation()
    func didSelectFuelDateCell(_ date: Date)
    func didUpdateFuelAmount(_ amount: Double)
}

// MARK: - FuelTableViewController
class FuelTableViewController: UITableViewController {
    
    weak var delegate: FuelTableViewControllerDelegate?

    var viewModel = FuelViewModel(Fuel.getEmpty()) {
        didSet { populateFuelAmountsFromVM() }
    }
    
    var dieselAmount: Double = 0 {
        didSet { updateDieselAmount(dieselAmount) }
    }
    
    var defAmount: Double = 0 {
        didSet { updateDefAmount(defAmount) }
    }
    
    var reeferAmount: Double = 0 {
        didSet { updateReeferAmount(reeferAmount) }
    }
    
    var totalAmount: Double {
        return dieselAmount + defAmount + reeferAmount
    }
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        populateFuelAmountsFromVM()
    }
    
    // Configuration
    func configure() {
        view.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.register(SectionTitleHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionTitleHeaderView.identifier)
        tableView.register(AddActionFooterView.self, forHeaderFooterViewReuseIdentifier: AddActionFooterView.identifier)
        tableView.register(FuelLocationCell.nib, forCellReuseIdentifier: FuelLocationCell.identifier)
        tableView.register(ItemDateCell.nib, forCellReuseIdentifier: ItemDateCell.identifier)
        tableView.register(FuelEntryCell.nib, forCellReuseIdentifier: FuelEntryCell.identifier)
        tableView.register(AttachmentCell.nib, forCellReuseIdentifier: AttachmentCell.identifier)
        tableView.register(NoAttachmentCell.nib, forCellReuseIdentifier: NoAttachmentCell.identifier)
    }
    
    // MARK: - View Model update
    // Location
    private func updateLocation(_ location: String) {
        for item in viewModel.items {
            if let locationItem = item as? FuelViewModelLocationItem {
                locationItem.location = location
            }
        }
    }
    
    public func updateRequestedLocation(_ location: String) {
        for (index, item) in viewModel.items.enumerated() {
            if let locationItem = item as? FuelViewModelLocationItem {
                locationItem.location = location
                tableView.reloadSections(IndexSet(integer: index), with: .none)
            }
        }
    }
    
    // Date
    public func updateDate(_ date: Date) {
        for (index, item) in viewModel.items.enumerated() {
            if let dateItem = item as? FuelViewModelDateItem {
                dateItem.date = date
                tableView.reloadSections(IndexSet(integer: index), with: .none)
            }
        }
    }
    
    // Total fuel amount
    private func notifyDelegateAmountChange() {
        delegate?.didUpdateFuelAmount(totalAmount)
    }
    
    public func updateFuelAmounts(with totalAmount: Double) {
        dieselAmount = totalAmount
        defAmount = 0
        reeferAmount = 0
        tableView.reloadData()
    }
    
    private func populateFuelAmountsFromVM() {
        for item in viewModel.items {
            if let dieselItem = item as? FuelViewModelDieselItem {
                dieselAmount = dieselItem.amount
                
            } else if let defItem = item as? FuelViewModelDefItem {
                defAmount = defItem.amount
                
            } else if let reeferItem = item as? FuelViewModelReeferItem {
                reeferAmount = reeferItem.amount
            }
        }
    }
    
    // Diesel
    private func updateDieselAmount(_ amount: Double) {
        for item in viewModel.items {
            if let dieselItem = item as? FuelViewModelDieselItem {
                dieselItem.amount = amount
            }
        }
    }
    
    // DEF
    private func updateDefAmount(_ amount: Double) {
        for item in viewModel.items {
            if let defItem = item as? FuelViewModelDefItem {
                defItem.amount = amount
            }
        }
    }
    
    // Reefer
    private func updateReeferAmount(_ amount: Double) {
        for item in viewModel.items {
            if let reeferItem = item as? FuelViewModelReeferItem {
                reeferItem.amount = amount
            }
        }
    }
    
    // MARK: - Data source
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
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: FuelLocationCell.identifier) as! FuelLocationCell
            cell.item = item
            
            cell.locationDidChange = { [weak self] newLocation in
                self?.updateLocation(newLocation)
            }
            
            cell.didTapGetCurrentLocation = { [weak self] in
                self?.delegate?.fuelDidRequestUserLocation()
            }
            
            return cell
            
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemDateCell.identifier) as! ItemDateCell
            let dateItem = item as? FuelViewModelDateItem
            cell.date = dateItem?.date
            
            cell.dateDidChange = { [weak self] newDate in
                self?.updateDate(newDate)
            }
            return cell
            
        case .diesel, .def, .reefer:
            let cell = tableView.dequeueReusableCell(withIdentifier: FuelEntryCell.identifier) as! FuelEntryCell
            cell.item = item
            
            cell.dieselAmountDidChange = { [weak self] amount in
                self?.dieselAmount = amount
                self?.notifyDelegateAmountChange()
            }
            
            cell.defAmountDidChange = { [weak self] amount in
                self?.defAmount = amount
                self?.notifyDelegateAmountChange()
            }
            
            cell.reeferAmountDidChange = { [weak self] amount in
                self?.reeferAmount = amount
                self?.notifyDelegateAmountChange()
            }
            
            return cell
            
        case .attachments:
            if let attachmentItem = item as? FuelViewModelAttachmentsItem, attachmentItem.hasAttachments {
                let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentCell.identifier) as! AttachmentCell
                cell.title = attachmentItem.attachments[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoAttachmentCell.identifier) as! NoAttachmentCell
                return cell
            }
        }
    }
    
    // MARK: - Delegate
    // Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.section]
        switch item.type {
        case .location:
            if let locationCell = tableView.cellForRow(at: indexPath) as? FuelLocationCell {
                locationCell.activateTextField()
            }
            
        case .date:
            if let dateItem = item as? FuelViewModelDateItem {
                delegate?.didSelectFuelDateCell(dateItem.date)
            }
            
        case .diesel, .def, .reefer:
            if let fuelEntryCell = tableView.cellForRow(at: indexPath) as? FuelEntryCell {
                fuelEntryCell.activateTextField()
            }
            
        case .attachments:
            //TODO: Show AttachmentVC
            return
        }
    }
    
    // Header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.items[section].type {
        case .attachments:
            return 30
        default:
            return 0
        }
    }
    
    // Row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.items[indexPath.section]
        switch item.type {
        case .attachments:
            guard let attachmentItem = item as? FuelViewModelAttachmentsItem else { return 0 }
            return attachmentItem.hasAttachments ? 45 : 65
        default:
            return 55
        }
    }
    
    // Footer height
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch viewModel.items[section].type {
        case .attachments:
            return 45
        default:
            return 0
        }
    }
    
    // Header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.items[section].type {
        case .attachments:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionTitleHeaderView.identifier) as! SectionTitleHeaderView
            headerView.titleColor = .dark
            headerView.titleSize = .small
            headerView.title = "Attachments"
            return headerView
        default:
            return nil
        }
    }
    
    // Footer view
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch viewModel.items[section].type {
        case .attachments:
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddActionFooterView.identifier) as! AddActionFooterView
            footerView.didTapAddButton = {
                //TODO: Add Attachment
            }
            return footerView
        default:
            return nil
        }
    }
}
