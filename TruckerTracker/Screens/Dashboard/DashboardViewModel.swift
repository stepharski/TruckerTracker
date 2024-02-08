//
//  DashboardViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/30/23.
//

import Foundation

class DashboardViewModel {
    
    private let dataManager = CoreDataManager.shared
    var dataChanged: Observable<Bool> = Observable(false)
    
    var totalIncome: Int {
        // TODO: Get real earning percent from settings
        let earningPercent = 0.9
        return Int(loadsAmount * earningPercent - expensesAmount - fuelingsAmount)
    }
    
    private var expensesAmount: Double = 0
    private var loadsAmount: Double = 0
    private var fuelingsAmount: Double = 0
    
    var segments: [ItemType] = ItemType.allCases
    var selectedSegment: Int = ItemType.load.index
    var selectedSegmentType: ItemType { return segments[selectedSegment] }
    
    var segmentTitles: [String] {
        let currency = UDManager.shared.currency.symbol
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
        didSet { UDManager.shared.dashboardPeriodType = dashboardPeriod.type }
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
    
    
    // Init
    init() {
        self.dashboardPeriod = Period.getCurrent()
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
    
    // Data handlers
    func fetchData() {
        fetchExpenses()
        fetchLoads()
        fetchFuelings()
        fetchItemsSum()
    }
    
    // Sum
    private func fetchItemsSum() {
        do { 
            expensesAmount = try dataManager.fetchExpensesSumAmount(in: dashboardPeriod)
            loadsAmount = try dataManager.fetchLoadsSumAmount(in: dashboardPeriod)
            fuelingsAmount = try dataManager.fetchFuelingsSumAmount(in: dashboardPeriod)
        } 
        catch let error as NSError { print(error) }
    }
    
    // Expenses
    func fetchExpenses() {
        do {
            self.expenses = try dataManager.fetchExpenses(in: dashboardPeriod)
            self.dataChanged.value = true
        }
        catch let error as NSError { print(error) }
        //TODO: Throw error to Controller ???
    }
    
    // Loads
    func fetchLoads() {
        do {
            self.loads = try dataManager.fetchLoads(in: dashboardPeriod)
            self.dataChanged.value = true
        }
        catch let error as NSError { print(error) }
        //TODO: Throw error to Controller ???
    }
    
    // Fuel
    func fetchFuelings() {
        do {
            self.fuelings = try dataManager.fetchFuelings(in: dashboardPeriod)
            self.dataChanged.value = true
        }
        catch let error as NSError { print(error) }
        //TODO: Throw error to Controller ???
    }
}
