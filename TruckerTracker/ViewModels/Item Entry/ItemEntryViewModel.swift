//
//  ItemEntryViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 7/2/23.
//

import Foundation

// MARK: - Item Location State
enum ItemLocationState {
    case idle
    case requesting
    case received
    case error(LocationError)
}

// MARK: - ItemEntry ViewModel
class ItemEntryViewModel {
    
    private(set) var amount: Double = 0
    private(set) var isNewItem: Bool = true
    private var initialItemType: ItemType = .load
    
    private(set) var segments = ItemType.allCases
    private(set) var selectedSegment: Observable<Int> = Observable(ItemType.load.index)
    var segmentTitles: [String] { return segments.map{ $0.title.capitalized }}
    var selectedSegmentType: ItemType { return segments[selectedSegment.value] }
    
    private var expenseTableViewModel: ExpenseTableViewModel?
    private var loadTableViewModel: LoadTableViewModel?
    private var fuelTableViewModel: FuelTableViewModel?
    
    private let dataManager = CoreDataManager.shared
    private let locationManager = LocationManager()
    private var locationRequestSegmentType: ItemType?
    var locationState: Observable<ItemLocationState> = Observable(.idle)
    var dataOperationResult: Observable<Result<Void, Error>?> = Observable(nil)
    
    
    // Init
    init(model: ItemModel? = nil) {
        isNewItem = false
        switch model {
        case .expense(let expense):
            amount = expense.amount
            initialItemType = .expense
            selectSegment(ItemType.expense.index)
            expenseTableViewModel = ExpenseTableViewModel(expense)
        case .load(let load):
            amount = load.amount
            initialItemType = .load
            selectSegment(ItemType.load.index)
            loadTableViewModel = LoadTableViewModel(load)
        case .fuel(let fuel):
            amount = fuel.totalAmount
            initialItemType = .fuel
            selectSegment(ItemType.fuel.index)
            fuelTableViewModel = FuelTableViewModel(fuel)
        case .none:
            amount = 0
            isNewItem = true
            initialItemType = .load
            selectSegment(ItemType.load.index)
            loadTableViewModel = LoadTableViewModel(nil)
        }
    }
    
    // Table View Models
    func getExpenseTableVM() -> ExpenseTableViewModel {
        return expenseTableViewModel ?? ExpenseTableViewModel(Expense.template())
    }
    
    func getLoadTableVM() -> LoadTableViewModel {
        return loadTableViewModel ?? LoadTableViewModel(nil)
    }
    
    func getFuelTableVM() -> FuelTableViewModel {
        return fuelTableViewModel ?? FuelTableViewModel(Fuel.template())
    }
    
    // Segments
    func selectSegment(_ index: Int) {
        guard selectedSegment.value != index else { return }
        selectedSegment.value = index
        stopLocationUpdates()
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
    
    // Location
    func requestUserLocation() {
        locationRequestSegmentType = selectedSegmentType
        locationState.value = .requesting
        setupLocationHandlers()
        locationManager.requestUserLocation()
    }
    
    private func setupLocationHandlers() {
        locationManager.didReceiveLocationInfo = { [weak self] location in
            guard let self = self else { return }
            guard let requestedSegment = locationRequestSegmentType else { return }
            guard requestedSegment == selectedSegmentType else { return }
            
            self.updateItemLocation(location)
            self.locationState.value = .received
        }
        
        locationManager.didFailToReceiveLocation = { [weak self] error in
            guard let self = self else { return }
            guard let requestedSegment = locationRequestSegmentType else { return }
            guard requestedSegment == selectedSegmentType else { return }
            
            self.locationState.value = .error(error)
        }
    }
    
    func stopLocationUpdates() {
        if case .requesting = locationState.value {
            locationState.value = .idle
            locationManager.stopLocationUpdates()
        }
    }
    
    // Data management
    func saveIfValid() {
        if let validationError = validateItem() {
            dataOperationResult.value = .failure(validationError)
            return
        }
        
        let itemTypeChanged = initialItemType != selectedSegmentType
        if !isNewItem && itemTypeChanged {
            deleteItem()
        }
        
        saveItem()
    }

    private func saveItem() {
        var result: Result<Void, Error>?
        
        switch selectedSegmentType {
        case .expense:
            print("save expense")
        case .load:
            result = loadTableViewModel?.save()
        case .fuel:
            print("save fuel")
        }
        
        guard let result = result else {
            // throw error
            return
        }
        
        switch result {
        case .success():
            print("load save success")
            dataOperationResult.value = .success(())
        case .failure(let error):
            print("load save failure")
            dataOperationResult.value = .failure(error)
        }
    }
    
    private func validateItem() -> ValidationError? {
        guard amount > 0 else { return .nullAmount }
        
        switch selectedSegmentType {
        case .expense:
            return nil
        case .load:
            return loadTableViewModel?.validateSections() ?? nil
        case .fuel:
            return nil
        }
    }
    
    func deleteItem() {
        //TODO: Delete item
    }
}
