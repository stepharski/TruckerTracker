//
//  LoadTableViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/22/23.
//

import UIKit

// MARK: - LoadTableViewController Delegate
protocol LoadTableViewControllerDelegate: AnyObject {
    func loadDidRequestUserLocation()
    func didSelectLoadDateCell(_ date: Date)
}

// MARK: - LoadTableViewController
class LoadTableViewController: UITableViewController {
    
    var viewModel = LoadTableViewModel(Load.template())
    weak var delegate: LoadTableViewControllerDelegate?
    
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
        tableView.register(LoadDistanceCell.nib, forCellReuseIdentifier: LoadDistanceCell.identifier)
        tableView.register(ItemDateCell.nib, forCellReuseIdentifier: ItemDateCell.identifier)
        tableView.register(LoadLocationCell.nib, forCellReuseIdentifier: LoadLocationCell.identifier)
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

    private func reloadSection(_ sectionType: LoadTableSectionType) {
        if let index = viewModel.getIndex(of: sectionType) {
            tableView.reloadSections(IndexSet(integer: index), with: .none)
        } else {
            tableView.reloadData()
        }
    }
    
    //MARK: - Data source
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
        case .emptyDistance, .tripDistance:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadDistanceCell.identifier)
                                                                        as! LoadDistanceCell
            cell.configure(for: section)
            
            cell.emptyDistanceDidChange = { [weak self] emptyDistance in
                self?.viewModel.updateEmptyDistance(emptyDistance)
            }
            
            cell.tripDistanceDidChange = { [weak self] tripDistance in
                self?.viewModel.updateTripDistance(tripDistance)
            }
            return cell
            
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemDateCell.identifier)
                                                                        as! ItemDateCell
            let dateSection = section as? LoadTableDateSection
            cell.date = dateSection?.date
            
            cell.dateDidChange = { [weak self] newDate in
                self?.viewModel.updateDate(newDate)
            }
            return cell
            
        case .startLocation, .endLocation:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadLocationCell.identifier)
                                                                    as! LoadLocationCell
            cell.configure(for: section)
            
            cell.startLocationDidChange = { [weak self] location in
                self?.viewModel.updateStartLocation(location)
            }
            
            cell.endLocationDidChange = { [weak self] location in
                self?.viewModel.updateEndLocation(location)
            }
            
            cell.didTapGetCurrentLocation = { [weak self] locationType in
                self?.viewModel.requestedLocation = locationType
                self?.delegate?.loadDidRequestUserLocation()
            }
            return cell
            
        case .attachments:
            guard let attachmentsSection = section as? LoadTableAttachmentsSection,
                                            attachmentsSection.hasAttachments else {
                return tableView.dequeueReusableCell(withIdentifier: ItemNoAttachmentCell.identifier)
                                                                        as! ItemNoAttachmentCell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemAttachmentCell.identifier)
                                                                        as! ItemAttachmentCell
            cell.title = attachmentsSection.attachments[indexPath.row]
            return cell
        }
    }

    //MARK: - Delegate
    // Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        switch section.type {
        case .tripDistance, .emptyDistance:
            if let distanceCell = tableView.cellForRow(at: indexPath) as? LoadDistanceCell {
                distanceCell.activateTextField()
            }
            
        case .date:
            if let dateItem = section as? LoadTableDateSection {
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
        case .startLocation, .endLocation:
            return 65
        case .attachments:
            guard let attachmentsSection = section as? LoadTableAttachmentsSection else { return 0 }
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
