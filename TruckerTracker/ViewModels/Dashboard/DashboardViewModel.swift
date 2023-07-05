//
//  DashboardViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/30/23.
//

import Foundation

class DashboardViewModel {
    
    var totalIncome: Int { //TODO: Calculate total income
        return 5500
    }
    
    var segments: [ItemType] = ItemType.allCases
    var selectedSegment: Int = ItemType.load.index
    
    var selectedSegmentType: ItemType {
        return segments[selectedSegment]
    }
    
    var segmentTitles: [String] {
        let currency = UDManager.shared.currency.symbol
        let expensesAmount = expenses.reduce(0, { $0 + $1.amount })
        let loadsAmount = loads.reduce(0, { $0 + $1.amount })
        let fuelingsAmount = fuelings.reduce(0, { $0 + $1.totalAmount })
        return ["\(currency)\(expensesAmount.formattedWithSeparator())",
                "\(currency)\(loadsAmount.formattedWithSeparator())",
                "\(currency)\(fuelingsAmount.formattedWithSeparator())"]
    }
    
    var segmentSubtitles: [String] {
        return segments.map { $0.pluralTitle }
    }
    
    var selectedSegmentSubtitle: String {
        return selectedSegmentType.subtitle
    }
    
    var dashboardPeriod: Period {
        get { return UDManager.shared.dashboardPeriod }
        set { UDManager.shared.dashboardPeriod = newValue }
    }
    
    private var expenses: [Expense] = []
    private var loads: [Load] = []
    private var fuelings: [Fuel] = []
    
    var numberOfItems: Int {
        switch selectedSegmentType {
        case .expense:  return expenses.count
        case .load:   return loads.count
        case .fuel:  return fuelings.count
        }
    }
    
    var emptyTableTitle: String {
        return "No \(selectedSegmentType.pluralTitle) found."
    }
    
    var emptyTableMessage: String {
        return "Please, tap the '+' button to add a new \(selectedSegmentType.title)."
    }
    
    // Table Models
    func model(at row: Int) -> ItemModel? {
        switch selectedSegmentType {
        case .expense:
            guard let expense = expenses[safe: row] else { return nil }
            return ItemModel.expense(expense)
        case .load:
            guard let load = loads[safe: row] else { return nil }
            return ItemModel.load(load)
        case .fuel:
            guard let fueling = fuelings[safe: row] else { return nil }
            return ItemModel.fuel(fueling)
        }
    }
    
    // Table ViewModels
    func expenseCellViewModel(for indexPath: IndexPath) -> ExpenseSummaryViewModel {
        return ExpenseSummaryViewModel(expenses[indexPath.row])
    }
    
    func loadCellViewModel(for indexPath: IndexPath) -> LoadSummaryViewModel {
        return LoadSummaryViewModel(loads[indexPath.row])
    }
    
    func fuelCellViewModel(for indexPath: IndexPath) -> FuelSummaryViewModel {
        return FuelSummaryViewModel(fuelings[indexPath.row])
    }
    
    //TODO: Add Core Data
    // Data Handling
    func fetchData(completion: @escaping((Bool) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.generateMockData()
            completion(true)
        }
    }
    
    // Mock
    private func generateMockData() {
        for i in 0..<5 {
            expenses.append(Expense(id: "expense\(i)", date: Date(), amount: 380,
                                    name: "Trailer rent", frequency: .week,
                                    attachments: ["Expense2023-30"]))

            loads.append(Load(id: "load\(i)", date: Date(), amount: 3200, distance: 964,
                              startLocation: "Chicago, IL", endLocation: "Atlanta, GA",
                                 attachments: ["RateCon2023-30"]))
            
            fuelings.append(Fuel(id: "fuel\(i)", date: Date(), dieselAmount: 540,
                                attachments: ["Receipt2023-30"]))
        }
    }
}
