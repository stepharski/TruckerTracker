//
//  HomeViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/30/23.
//

import Foundation

class HomeViewModel {
    
    private(set) var totalIncome: Int = 0
    
    private(set) var expenses: [Expense] = []
    private(set) var loads: [Load] = []
    private(set) var fuelings: [Fuel] = []
    
    
    // Cell VMs
    func expenseCellViewModel(for indexPath: IndexPath) -> ExpenseCellViewModel {
        return ExpenseCellViewModel(expenses[indexPath.row])
    }
    
    func loadCellViewModel(for indexPath: IndexPath) -> LoadCellViewModel {
        return LoadCellViewModel(loads[indexPath.row])
    }
    
    func fuelCellViewModel(for indexPath: IndexPath) -> FuelCellViewModel {
        return FuelCellViewModel(fuelings[indexPath.row])
    }
    
    // Data handling
    func getTotalIncome() -> String {
        //TODO: Calculate Income
        return "\(UDManager.shared.currency.symbol) \(totalIncome.formattedWithSeparator())"
    }
    
    func getCategoryNames() -> [String] {
        ItemType.allCases.map { $0.pluralTitle }
    }
    
    func getCategoryTotals() -> [String] {
        var expensesAmount: Double = 0
        var loadsAmount: Double = 0
        var fuelingsAmount: Double = 0
        
        expenses.forEach { expensesAmount += $0.amount }
        loads.forEach { loadsAmount += $0.amount }
        fuelings.forEach { fuelingsAmount += $0.totalAmount }
        
        return ["\(expensesAmount.formattedWithSeparator())",
                "\(loadsAmount.formattedWithSeparator())",
                "\(fuelingsAmount.formattedWithSeparator())"]
    }
    
    func getNumberOfItems(for type: ItemType) -> Int {
        switch type {
        case .expense:
            return expenses.count
        case .load:
            return loads.count
        case .fuel:
            return fuelings.count
        }
    }
    
    // Data fetch
    func fetchData(for period: Period, completion: @escaping((Bool) -> Void)) {
        //TODO: Fetch from CoreData
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.generateMockData()
            completion(true)
        }
    }
    
    // Mock data
    private func generateMockData() {
        totalIncome = 5500
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
