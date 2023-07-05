//
//  ItemEntryViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 7/2/23.
//

import Foundation

class ItemEntryViewModel {
    
    private(set) var isNewItem = true
    private(set) var amount: Double = 0
    
    private var expenseTableViewModel: ExpenseTableViewModel?
    private var loadTableViewModel: LoadTableViewModel?
    private var fuelTableViewModel: FuelTableViewModel?
    
    private(set) var segments = ItemType.allCases
    private(set) var selectedSegment: Observable<Int> = Observable(ItemType.load.index)
    
    var selectedSegmentType: ItemType {
        return segments[selectedSegment.value]
    }
    
    var segmentTitles: [String] {
        return segments.map { $0.title.capitalized }
    }
    
    // Init
    init(model: ItemModel? = nil) {
        isNewItem = false
        switch model {
        case .expense(let expense):
            amount = expense.amount
            selectedSegment.value = ItemType.expense.index
            expenseTableViewModel = ExpenseTableViewModel(expense)
        case .load(let load):
            amount = load.amount
            selectedSegment.value = ItemType.load.index
            loadTableViewModel = LoadTableViewModel(load)
        case .fuel(let fuel):
            amount = fuel.totalAmount
            selectedSegment.value = ItemType.fuel.index
            fuelTableViewModel = FuelTableViewModel(fuel)
        case .none:
            amount = 0
            isNewItem = true
            selectedSegment.value = ItemType.load.index
            loadTableViewModel = LoadTableViewModel(Load.template())
        }
    }
    
    // Table View Models
    func getExpenseTableVM() -> ExpenseTableViewModel {
        expenseTableViewModel = expenseTableViewModel ?? ExpenseTableViewModel(Expense.template())
        return expenseTableViewModel!
    }
    
    func getLoadTableVM() -> LoadTableViewModel {
        loadTableViewModel = loadTableViewModel ?? LoadTableViewModel(Load.template())
        return loadTableViewModel!
    }
    
    func getFuelTableVM() -> FuelTableViewModel {
        fuelTableViewModel = fuelTableViewModel ?? FuelTableViewModel(Fuel.template())
        return fuelTableViewModel!
    }
    
    // Segments
    func selectSegment(_ index: Int) {
        guard selectedSegment.value != index else { return }
        selectedSegment.value = index
    }
    
    // Updates
    func updateItemAmount(_ amount: Double) {
        self.amount = amount
        updateFuelTableAmountsIfNeeded()
    }
    
    func updateFuelTableAmountsIfNeeded() {
        guard selectedSegmentType == .fuel else { return }
        guard fuelTableViewModel?.totalFuelAmount.value != amount else { return }
        
        fuelTableViewModel?.distributeTotalAmountChange(amount)
    }
    
    func updateItemLocation(_ location: String) {
        switch selectedSegmentType {
        case .expense:
            return
        case .load:
            loadTableViewModel?.updateRequestedLocation(location)
        case .fuel:
            fuelTableViewModel?.updateRequestedLocation(location)
        }
    }
    
    func updateItemDate(_ date: Date) {
        switch selectedSegmentType {
        case .expense:
            expenseTableViewModel?.updateDate(date)
        case .load:
            loadTableViewModel?.updateDate(date)
        case .fuel:
            fuelTableViewModel?.updateDate(date)
        }
    }
    
    func updateItemFrequency(_ frequency: FrequencyType?) {
        guard let frequency = frequency, selectedSegmentType == .expense else { return }
        expenseTableViewModel?.updateFrequency(frequency)
    }
}
