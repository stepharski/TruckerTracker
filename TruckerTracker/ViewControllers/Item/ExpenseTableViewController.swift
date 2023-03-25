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
    
    var viewModel = ExpenseViewModel(Expense.getDefault())
    weak var delegate: ExpenseTableViewControllerDelegate?
    
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // Configuration
    func configure() {
        view.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        
        tableView.register(NameCell.nib, forCellReuseIdentifier: NameCell.identifier)
        tableView.register(ItemDateCell.nib, forCellReuseIdentifier: ItemDateCell.identifier)
        tableView.register(ExpenseFrequencyCell.nib, forCellReuseIdentifier: ExpenseFrequencyCell.identifier)
        tableView.register(ExpenseNoteCell.nib, forCellReuseIdentifier: ExpenseNoteCell.identifier)
        tableView.register(DocumentCell.nib, forCellReuseIdentifier: DocumentCell.identifier)
    }
    
    // MARK: - View Model update
    // Name
    private func updateName(_ name: String) {
        for item in viewModel.items {
            if let nameItem = item as? ExpenseViewModelNameItem {
                nameItem.name = name
            }
        }
    }
    
    // Date
    func updateDate(_ date: Date) {
        for (index, item) in viewModel.items.enumerated() {
            if let dateItem = item as? ExpenseViewModelDateItem {
                dateItem.date = date
                tableView.reloadSections(IndexSet(integer: index), with: .none)
            }
        }
    }
    
    // Frequency
    func updateFrequency(_ frequency: FrequencyType) {
        for (index, item) in viewModel.items.enumerated() {
            if let frequencyItem = item as? ExpenseViewModelFrequencyItem {
                frequencyItem.frequency = frequency
                tableView.reloadSections(IndexSet(integer: index), with: .none)
            }
        }
    }
    
    // Note
    func updateNote(_ note: String) {
        for item in viewModel.items {
            if let noteItem = item as? ExpenseViewModelNoteItem {
                noteItem.note = note
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
            
        case .name:
            let cell = tableView.dequeueReusableCell(withIdentifier: NameCell.identifier)
                                                                        as! NameCell
            let nameItem = item as? ExpenseViewModelNameItem
            cell.titleImage = nameItem?.image
            cell.name = nameItem?.name
            
            cell.nameDidChange = { [weak self] newName in
                self?.updateName(newName)
            }
            return cell
            
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: ItemDateCell.identifier)
                                                                        as! ItemDateCell
            let dateItem = item as? ExpenseViewModelDateItem
            cell.date = dateItem?.date
            
            cell.dateDidChange = { [weak self] newDate in
                self?.updateDate(newDate)
            }
            return cell
            
        case .frequency:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseFrequencyCell.identifier)
                                                                        as! ExpenseFrequencyCell
            cell.item = item
            return cell
            
        case .note:
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseNoteCell.identifier)
                                                                        as! ExpenseNoteCell
            cell.item = item
            
            cell.noteDidChange = { [weak self] newNote in
                self?.updateNote(newNote)
            }
            
            return cell
            
        case .documents:
            let cell = tableView.dequeueReusableCell(withIdentifier: DocumentCell.identifier)
                                                                        as! DocumentCell
            let documentItem = item as? ExpenseViewModelDocumentsItem
            cell.documentName = documentItem?.documents[indexPath.row]
            return cell
        }
    }
    
    // MARK: - Delegate
    // Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.section]
        switch item.type {
            
        case .name:
            if let nameCell = tableView.cellForRow(at: indexPath) as? NameCell {
                nameCell.activateTextField()
            }
            
        case .date:
            if let dateItem = item as? ExpenseViewModelDateItem {
                delegate?.didSelectExpenseDateCell(dateItem.date)
            }
            
        case .frequency:
            if let frequencyItem = item as? ExpenseViewModelFrequencyItem {
                delegate?.didSelectExpenseFrequencyCell(frequencyItem.frequency)
            }
            
        case .note:
            if let noteCell = tableView.cellForRow(at: indexPath) as? ExpenseNoteCell {
                noteCell.activateTextField()
            }
            
        case .documents:
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
        return 55
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
