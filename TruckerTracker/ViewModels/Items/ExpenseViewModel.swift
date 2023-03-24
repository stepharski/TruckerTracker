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
    case documents
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
        let model = expense ?? Expense.getDefault()
        
        items.append(ExpenseViewModelNameItem(name: model.name))
        items.append(ExpenseViewModelDateItem(date: model.date))
        items.append(ExpenseViewModelFrequencyItem(frequency: model.frequency))
        items.append(ExpenseViewModelNoteItem(note: model.note ?? ""))
        items.append(ExpenseViewModelDocumentsItem(documents: model.documents ?? []))
    }
}

// Name
class ExpenseViewModelNameItem: ExpenseViewModelItem {
    var type: ExpenseViewModelItemType = .name
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

// Date
class ExpenseViewModelDateItem: ExpenseViewModelItem {
    var type: ExpenseViewModelItemType = .date
    var date: Date
    
    var title: String {
        return Calendar.current.isDateInToday(date) ? "Today" : date.convertToMonthDayFormat()
    }
    
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

// Documents
class ExpenseViewModelDocumentsItem: ExpenseViewModelItem {
    var type: ExpenseViewModelItemType = .documents
    var rowCount: Int { return documents.count }
    var sectionTitle: String = "Documents"
    var documents: [String]
    
    init(documents: [String]) {
        self.documents = documents
    }
}
