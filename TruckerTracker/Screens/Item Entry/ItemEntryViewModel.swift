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
    private(set) var itemDate: Date = Date()
    private(set) var isNewItem: Bool = true
    private var initialItemType: ItemType = .load
    private var itemTypeChanged: Bool { return initialItemType != selectedSegmentType }
    
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
            itemDate = expense.date
            initialItemType = .expense
            selectSegment(ItemType.expense.index)
            expenseTableViewModel = ExpenseTableViewModel(expense)
        case .load(let load):
            amount = load.amount
            itemDate = load.date
            initialItemType = .load
            selectSegment(ItemType.load.index)
            loadTableViewModel = LoadTableViewModel(load)
        case .fuel(let fuel):
            amount = fuel.totalAmount
            itemDate = fuel.date
            initialItemType = .fuel
            selectSegment(ItemType.fuel.index)
            fuelTableViewModel = FuelTableViewModel(fuel)
        case .none:
            amount = 0
            isNewItem = true
            itemDate = .now.local
            initialItemType = .load
            selectSegment(ItemType.load.index)
            loadTableViewModel = LoadTableViewModel(nil)
        }
    }
    
    // Table View Models
    func getExpenseTableVM() -> ExpenseTableViewModel {
        return expenseTableViewModel ?? {
            let newExpenseTableVM = ExpenseTableViewModel(nil)
            self.expenseTableViewModel = newExpenseTableVM
            return newExpenseTableVM
        }()
    }
    
    func getLoadTableVM() -> LoadTableViewModel {
        return loadTableViewModel ?? {
            let newLoadTableVM = LoadTableViewModel(nil)
            self.loadTableViewModel = newLoadTableVM
            return newLoadTableVM
        }()
    }
    
    func getFuelTableVM() -> FuelTableViewModel {
        return fuelTableViewModel ?? {
            let newFuelTableVM = FuelTableViewModel(nil)
            self.fuelTableViewModel = newFuelTableVM
            return newFuelTableVM
        }()
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
        itemDate = date
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

// MARK: - Location request
extension ItemEntryViewModel {
    // Request current location
    func requestUserLocation() {
        locationRequestSegmentType = selectedSegmentType
        locationState.value = .requesting
        setupLocationHandlers()
        locationManager.requestUserLocation()
    }
    
    // Handlers
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
    
    // Updates
    func stopLocationUpdates() {
        if case .requesting = locationState.value {
            locationState.value = .idle
            locationManager.stopLocationUpdates()
        }
    }
}

// MARK: - Core Data Handling
extension ItemEntryViewModel {
    // Save processing
    func saveIfValid() {
        if let validationError = validateItem() {
            dataOperationResult.value = .failure(validationError)
            return
        }
        
        if isNewItem {
            saveNewItem()
        } else if !isNewItem && !itemTypeChanged {
            // Edit existing item of same type
            saveItemChanges()
        } else if !isNewItem && itemTypeChanged {
            // Change existing item type
            deleteInitialItem()
            saveNewItem()
        }
    }
    
    // Validate
    private func validateItem() -> ValidationError? {
        guard amount > 0 else { return .itemNullAmount }
        
        switch selectedSegmentType {
        case .expense:
            return expenseTableViewModel?.validateSections() ?? nil
        case .load:
            return loadTableViewModel?.validateSections() ?? nil
        case .fuel:
            return nil
        }
    }
    
    // Save new
    private func saveNewItem() {
        var result: Result<Void, Error>?
        
        switch selectedSegmentType {
        case .expense:
            result = expenseTableViewModel?.save(with: amount)
        case .load:
            result = loadTableViewModel?.save(with: amount)
        case .fuel:
            result = fuelTableViewModel?.save()
        }
        
        handleOperationResult(result)
    }
    
    // Save changes
    private func saveItemChanges() {
        do { 
            try dataManager.saveChanges()
            handleOperationResult(.success(()))
        } catch {
            handleOperationResult(.failure(error))
        }
    }
    
    // Delete initial
    func deleteInitialItem() {
        var result: Result<Void, Error>?
        
        switch initialItemType {
        case .expense:
            result = expenseTableViewModel?.delete()
        case .load:
            result = loadTableViewModel?.delete()
        case .fuel:
            result = fuelTableViewModel?.delete()
        }
        
        handleOperationResult(result)
    }
    
    // Result
    private func handleOperationResult(_ result: Result<Void, Error>?) {
        guard let result = result else {
            dataOperationResult.value = .failure(OperationError.dataProcessingError)
            return
        }
        
        switch result {
        case .success():
            print("Saving Operation Success")
            dataOperationResult.value = .success(())
        case .failure(let error):
            print("Saving Operation Failure")
            dataOperationResult.value = .failure(error)
        }
    }

}
