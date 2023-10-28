//
//  ItemEntryViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 7/2/23.
//

import Foundation

// MARK: -
enum ItemValidationError {
    
}

// MARK: - Item Location State
enum ItemLocationState {
    case idle
    case requesting
    case received
    case error(LocationError)
}

// MARK: - ItemEntry ViewModel
class ItemEntryViewModel {
    
    private(set) var isNewItem = true
    private(set) var amount: Double = 0
    
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
    var validationState: Observable<ValidationError?> = Observable(nil)
    
    
    // Init
    init(model: ItemModel? = nil) {
        isNewItem = false
        switch model {
        case .expense(let expense):
            amount = expense.amount
            selectSegment(ItemType.expense.index)
            expenseTableViewModel = ExpenseTableViewModel(expense)
        case .load(let load):
            amount = load.amount
            selectSegment(ItemType.load.index)
            loadTableViewModel = LoadTableViewModel(load)
        case .fuel(let fuel):
            amount = fuel.totalAmount
            selectSegment(ItemType.fuel.index)
            fuelTableViewModel = FuelTableViewModel(fuel)
        case .none:
            amount = 0
            isNewItem = true
            selectSegment(ItemType.load.index)
            loadTableViewModel = LoadTableViewModel(dataManager.createEmptyLoad())
        }
    }
    
    // Table View Models
    func getExpenseTableVM() -> ExpenseTableViewModel {
        return expenseTableViewModel ?? ExpenseTableViewModel(Expense.template())
    }
    
    func getLoadTableVM() -> LoadTableViewModel {
        return loadTableViewModel ?? LoadTableViewModel(dataManager.createEmptyLoad())
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
    func saveItem() {
        if let validationError = validateItem() {
            validationState.value = validationError
            return
        }
        
        switch selectedSegmentType {
        case .expense:
            print("expense save")
            
        case .load:
            print("load save")
            
        case .fuel:
            print("fuel save")
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
