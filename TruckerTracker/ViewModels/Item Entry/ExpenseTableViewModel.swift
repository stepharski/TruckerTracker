//
//  ExpenseTableViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/23/23.
//

import UIKit

// MARK: - Type
enum ExpenseTableSectionType {
    case name
    case date
    case frequency
    case note
    case attachments
}

protocol ExpenseTableSection {
    var type: ExpenseTableSectionType { get }
    var rowCount: Int { get }
}

extension ExpenseTableSection {
    var rowCount: Int { return 1 }
}

// MARK: - ExpenseTable ViewModel
class ExpenseTableViewModel {
    private var expense: Expense!
    var sections = [ExpenseTableSection]()
    var sectionToReload: Observable<ExpenseTableSectionType?> = Observable(nil)
    
    // Init
    init(_ expense: Expense) {
        self.expense = expense
        sections.append(ExpenseTableNameSection(expense.name))
        sections.append(ExpenseTableDateSection(expense.date))
        sections.append(ExpenseTableFrequencySection(expense.frequency))
        sections.append(ExpenseTableNoteSection(expense.note ?? ""))
        sections.append(ExpenseTableAttachmentsSection(expense.attachments ?? []))
    }
    
    // Section Index
    func getIndex(of sectionType: ExpenseTableSectionType) -> Int? {
        return sections.firstIndex(where: { $0.type == sectionType })
    }
    
    // Section Updates
    func updateName(_ name: String) {
        if let nameSection = sections.first(where: { $0.type == .name }) as? ExpenseTableNameSection {
            self.expense.name = name
            nameSection.name = name
        }
    }
    
    func updateDate(_ date: Date) {
        if let dateSection = sections.first(where: { $0.type == .date }) as? ExpenseTableDateSection {
            self.expense.date = date
            dateSection.date = date
            sectionToReload.value = .date
        }
    }
    
    func updateFrequency(_ frequency: FrequencyType) {
        if let frequencySection = sections.first(where: { $0.type == .frequency })
                                                    as? ExpenseTableFrequencySection {
            self.expense.frequency = frequency
            frequencySection.frequency = frequency
            sectionToReload.value = .frequency
        }
    }
    
    func updateNote(_ note: String) {
        if let noteSection = sections.first(where: { $0.type == .note }) as? ExpenseTableNoteSection {
            self.expense.note = note
            noteSection.note = note
        }
    }
    
    func updateAttachments(_ attachments: [String]) {
        if let attachmentsSection = sections.first(where: { $0.type == .attachments })
                                                    as? ExpenseTableAttachmentsSection {
            self.expense.attachments = attachments
            attachmentsSection.attachments = attachments
            sectionToReload.value = .attachments
        }
    }
}

// MARK: - Sections
// Name
class ExpenseTableNameSection: ExpenseTableSection {
    var type: ExpenseTableSectionType = .name
    var image: UIImage? = SFSymbols.scribble
    var name: String
    
    init(_ name: String) {
        self.name = name
    }
}

// Date
class ExpenseTableDateSection: ExpenseTableSection {
    var type: ExpenseTableSectionType = .date
    var date: Date
    
    init(_ date: Date) {
        self.date = date
    }
}

// Frequency
class ExpenseTableFrequencySection: ExpenseTableSection {
    var type: ExpenseTableSectionType = .frequency
    var image: UIImage? { return frequency.image }
    var title: String { return frequency.title }
    var frequency: FrequencyType
    
    init(_ frequency: FrequencyType) {
        self.frequency = frequency
    }
}

// Note
class ExpenseTableNoteSection: ExpenseTableSection {
    var type: ExpenseTableSectionType = .note
    var note: String
    
    init(_ note: String) {
        self.note = note
    }
}

// Attachments
class ExpenseTableAttachmentsSection: ExpenseTableSection {
    var type: ExpenseTableSectionType = .attachments
    var rowCount: Int { return hasAttachments ? attachments.count : 1}
    var hasAttachments: Bool { return attachments.count > 0 }
    var attachments: [String] //TODO: Create model
    
    init(_ attachments: [String]) {
        self.attachments = attachments
    }
}
