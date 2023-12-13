//
//  ExpenseTableViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/23/23.
//

import UIKit

// MARK: - ExpenseTableViewControllerDelegate
protocol ExpenseTableViewControllerDelegate: AnyObject {
    func didSelectExpenseDateCell(_ date: Date)
    func didSelectExpenseFrequencyCell(_ frequency: FrequencyType)
}

// MARK: - ExpenseTableViewController
class ExpenseTableViewController: UITableViewController {
    
    var viewModel: ExpenseTableViewModel
    weak var delegate: ExpenseTableViewControllerDelegate?
    
    // Life cycle
    init(viewModel: ExpenseTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        tableView.register(SectionTitleHeaderView.self,
                         forHeaderFooterViewReuseIdentifier: SectionTitleHeaderView.identifier)
        tableView.register(ItemNameCell.nib, forCellReuseIdentifier: ItemNameCell.identifier)
        tableView.register(ItemDateCell.nib, forCellReuseIdentifier: ItemDateCell.identifier)
        tableView.register(ExpenseFrequencyCell.nib, forCellReuseIdentifier: ExpenseFrequencyCell.identifier)
        tableView.register(ExpenseNoteCell.nib, forCellReuseIdentifier: ExpenseNoteCell.identifier)
        tableView.register(ItemAttachmentCell.nib, forCellReuseIdentifier: ItemAttachmentCell.identifier)
        tableView.register(ItemNoAttachmentCell.nib, forCellReuseIdentifier: ItemNoAttachmentCell.identifier)
        tableView.register(AddActionFooterView.self, forHeaderFooterViewReuseIdentifier: AddActionFooterView.identifier)
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
    
    private func reloadSection(_ sectionType: ExpenseTableSectionType) {
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
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemNameCell.identifier)
                                                                        as! ItemNameCell
            let nameSection = section as? ExpenseTableNameSection
            cell.titleImage = nameSection?.image
            cell.name = nameSection?.name
            
            cell.nameDidChange = { [weak self] newName in
                self?.viewModel.updateName(newName)
            }
            return cell
            
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemDateCell.identifier)
                                                                        as! ItemDateCell
            let dateSection = section as? ExpenseTableDateSection
            cell.date = dateSection?.date
            
            cell.dateDidChange = { [weak self] newDate in
                self?.viewModel.updateDate(newDate)
            }
            
            return cell
            
        case .frequency:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseFrequencyCell.identifier)
                                                                        as! ExpenseFrequencyCell
            let frequencySection = section as? ExpenseTableFrequencySection
            cell.frequencyImage = frequencySection?.image
            cell.frequencyTitle = frequencySection?.title
            return cell
            
        case .note:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseNoteCell.identifier)
                                                                        as! ExpenseNoteCell
            let noteSection = section as? ExpenseTableNoteSection
            cell.noteText = noteSection?.note
            
            cell.noteDidChange = { [weak self] newNote in
                self?.viewModel.updateNote(newNote)
            }
            return cell
            
        case .attachments:
            if let attachmentsSection = section as? ExpenseTableAttachmentsSection,
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
        case .name:
            if let nameCell = tableView.cellForRow(at: indexPath) as? ItemNameCell {
                nameCell.activateTextField()
            }

        case .date:
            if let dateSection = section as? ExpenseTableDateSection {
                delegate?.didSelectExpenseDateCell(dateSection.date)
            }
            
        case .frequency:
            if let frequencySection = section as? ExpenseTableFrequencySection {
                delegate?.didSelectExpenseFrequencyCell(frequencySection.frequency)
            }
            
        case .note:
            if let noteCell = tableView.cellForRow(at: indexPath) as? ExpenseNoteCell {
                noteCell.activateTextField()
            }
            
        case .attachments:
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
            guard let attachmentsSection = section as? ExpenseTableAttachmentsSection else { return 0 }
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
