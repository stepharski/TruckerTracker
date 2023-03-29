//
//  ExpenseViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/23/23.
//

import UIKit

// MARK: - ExpenseViewModelItemType
enum ExpenseViewModelItemType {
    case name
    case date
    case frequency
    case note
    case attachments
}

// MARK: - ExpenseViewModelItem
protocol ExpenseViewModelItem {
    var type: ExpenseViewModelItemType { get }
    var rowCount: Int { get }
}

extension ExpenseViewModelItem {
    var rowCount: Int { return 1 }
}

// MARK: - ExpenseViewModel
class ExpenseViewModel {
    var items = [ExpenseViewModelItem]()
    
    init(_ expense: Expense?) {
        let model = expense ?? Expense.getEmpty()
        
        items.append(ExpenseViewModelNameItem(name: model.name))
        items.append(ExpenseViewModelDateItem(date: model.date))
        items.append(ExpenseViewModelFrequencyItem(frequency: model.frequency))
        items.append(ExpenseViewModelNoteItem(note: model.note ?? ""))
        items.append(ExpenseViewModelAttachmentsItem(attachments: model.attachments ?? []))
    }
}

// Name
class ExpenseViewModelNameItem: ExpenseViewModelItem {
    var type: ExpenseViewModelItemType = .name
    var image: UIImage? = SFSymbols.scribble
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

// Date
class ExpenseViewModelDateItem: ExpenseViewModelItem {
    var type: ExpenseViewModelItemType = .date
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
}

// Frequency
class ExpenseViewModelFrequencyItem: ExpenseViewModelItem {
    var type: ExpenseViewModelItemType = .frequency
    var frequency: FrequencyType
    
    init(frequency: FrequencyType) {
        self.frequency = frequency
    }
}

// Note
class ExpenseViewModelNoteItem: ExpenseViewModelItem {
    var type: ExpenseViewModelItemType = .note
    var note: String
    
    init(note: String) {
        self.note = note
    }
}

// Attachments
class ExpenseViewModelAttachmentsItem: ExpenseViewModelItem {
    var type: ExpenseViewModelItemType = .attachments
    var rowCount: Int { return hasAttachments ? attachments.count : 1}
    var hasAttachments: Bool { return attachments.count > 0 }
    var attachments: [String]
    
    init(attachments: [String]) {
        self.attachments = attachments
    }
}
