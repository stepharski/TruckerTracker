//
//  FuelTableViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/23/23.
//

import UIKit

// MARK: - FuelTable ViewController Delegate
protocol FuelTableViewControllerDelegate: AnyObject {
    func fuelDidRequestUserLocation()
    func didSelectFuelDateCell(_ date: Date)
}

// MARK: - FuelTable ViewController
class FuelTableViewController: UITableViewController {
    
    var viewModel = FuelTableViewModel(Fuel.template())
    weak var delegate: FuelTableViewControllerDelegate?
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupBinders()
    }
    
    // Configuration
    private func configure() {
        view.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.register(SectionTitleHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionTitleHeaderView.identifier)
        tableView.register(AddActionFooterView.self, forHeaderFooterViewReuseIdentifier: AddActionFooterView.identifier)
        tableView.register(FuelLocationCell.nib, forCellReuseIdentifier: FuelLocationCell.identifier)
        tableView.register(ItemDateCell.nib, forCellReuseIdentifier: ItemDateCell.identifier)
        tableView.register(FuelEntryCell.nib, forCellReuseIdentifier: FuelEntryCell.identifier)
        tableView.register(ItemAttachmentCell.nib, forCellReuseIdentifier: ItemAttachmentCell.identifier)
        tableView.register(ItemNoAttachmentCell.nib, forCellReuseIdentifier: ItemNoAttachmentCell.identifier)
    }
    
    // Binders
    private func setupBinders() {
        viewModel.sectionToReload.bind({ [weak self] section in
            DispatchQueue.main.async {
                guard let self = self, let section = section else { return }
                self.reloadSection(section)
            }
        })
    }
    
    private func reloadSection(_ sectionType: FuelTableSectionType) {
        if let index = viewModel.getIndex(of: sectionType) {
            tableView.reloadSections(IndexSet(integer: index), with: .none)
        } else {
            tableView.reloadData()
        }
    }
    
    // MARK: - Data source
    // Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].rowCount
    }
    
    // Cell for row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        switch section.type {
        case .location:
            let cell = tableView.dequeueReusableCell(withIdentifier: FuelLocationCell.identifier)
                                                                        as! FuelLocationCell
            let locationSection = section as? FuelTableLocationSection
            cell.location = locationSection?.location
            
            cell.locationDidChange = { [weak self] newLocation in
                self?.viewModel.updateLocation(newLocation)
            }
            
            cell.didTapGetCurrentLocation = { [weak self] in
                self?.delegate?.fuelDidRequestUserLocation()
            }
            return cell
            
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemDateCell.identifier)
                                                                        as! ItemDateCell
            let dateSection = section as? FuelTableDateSection
            cell.date = dateSection?.date
            
            cell.dateDidChange = { [weak self] newDate in
                self?.viewModel.updateDate(newDate)
            }
            return cell
            
        case .diesel, .def, .reefer:
            let cell = tableView.dequeueReusableCell(withIdentifier: FuelEntryCell.identifier)
                                                                        as! FuelEntryCell
            cell.configure(for: section)
            
            cell.dieselAmountDidChange = { [weak self] amount in
                self?.viewModel.updateDieselAmount(amount)
            }
            
            cell.defAmountDidChange = { [weak self] amount in
                self?.viewModel.updateDefAmount(amount)
            }
            
            cell.reeferAmountDidChange = { [weak self] amount in
                self?.viewModel.updateReeferAmount(amount)
            }
            return cell
            
        case .attachments:
            if let attachmentsSection = section as? FuelTableAttachmentsSection,
                                            attachmentsSection.hasAttachments {
                let cell = tableView.dequeueReusableCell(withIdentifier: ItemAttachmentCell.identifier)
                                                                            as! ItemAttachmentCell
                cell.title = attachmentsSection.attachments[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ItemNoAttachmentCell.identifier)
                                                                            as! ItemNoAttachmentCell
                return cell
            }
        }
    }
    
    // MARK: - Delegate
    // Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        switch section.type {
        case .location:
            if let locationCell = tableView.cellForRow(at: indexPath) as? FuelLocationCell {
                locationCell.activateTextField()
            }
            
        case .date:
            if let dateSection = section as? FuelTableDateSection {
                delegate?.didSelectFuelDateCell(dateSection.date)
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
        switch viewModel.sections[section].type {
        case .attachments:
            return 30
        default:
            return 0
        }
    }
    
    // Row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = viewModel.sections[indexPath.section]
        switch section.type {
        case .attachments:
            guard let attachmentsSection = section as? FuelTableAttachmentsSection else { return 0 }
            return attachmentsSection.hasAttachments ? 45 : 65
        default:
            return 55
        }
    }
    
    // Footer height
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch viewModel.sections[section].type {
        case .attachments:
            return 45
        default:
            return 0
        }
    }
    
    // Header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.sections[section].type {
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
        switch viewModel.sections[section].type {
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
