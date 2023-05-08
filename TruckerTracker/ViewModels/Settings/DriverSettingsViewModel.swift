//
//  DriverSettingsViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/3/23.
//

import UIKit

// MARK: - DriverSettings Type
enum DriverSettingsType {
    case name
    case driverType
    case payRate
}

// MARK: - DriverSettings ViewModel Option
protocol DriverSettingsViewModelOption {
    var type: DriverSettingsType { get }
    var image: UIImage? { get }
    var title: String { get }
}

// MARK: - DriverSettings ViewModel
class DriverSettingsViewModel {
    
    var options: [DriverSettingsViewModelOption]
    
    init() {
        options = [ DriverSettingsNameOption(),         // Name
                    DriverSettingsTypeOption(),       // Type
                    DriverSettingsPayRateOption() ]  // Pay rate
    }
    
    //TODO: Fetch/Save data in CoreData
    func updateName(with name: String) { }
    
    func updateTeamStatus(with isTeam: Bool ) { }
    
    func updatePayRate(with payRate: Double) {  }
}


// MARK: - DriverSettingsViewModel Options definition
// Name
class DriverSettingsNameOption: DriverSettingsViewModelOption {
    var type: DriverSettingsType = .name
    var image: UIImage? = SFSymbols.personIdCard
    var title: String = "Name"
    
    //TODO: Fetch/Assign in CoreData
    var name: String?
}

// Type
class DriverSettingsTypeOption: DriverSettingsViewModelOption {
    var type: DriverSettingsType = .driverType
    var image: UIImage? = SFSymbols.personTwo
    var title: String = "Type"
    
    // TODO: Fetch/Save in CoreData
    var isTeamDriver: Bool { return false }
}

// Pay rate
class DriverSettingsPayRateOption: DriverSettingsViewModelOption {
    var type: DriverSettingsType = .payRate
    var image: UIImage? = SFSymbols.scissors
    var title: String = "Pay rate"
    
    // TODO: Fetch/Save in CoreData
    var payRate: Float { return 88 }
}
