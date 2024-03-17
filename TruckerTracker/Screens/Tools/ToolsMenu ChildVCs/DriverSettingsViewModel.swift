//
//  DriverSettingsViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/3/23.
//

import UIKit

//TODO: Change Option to Setting

// MARK: - DriverSettings Type
enum DriverSettingsType {
    case name
    case driverType
    case payRate
}

// MARK: - DriverSettingsOption ViewModel
protocol DriverSettingsOptionViewModel {
    var type: DriverSettingsType { get }
    var image: UIImage? { get }
    var title: String { get }
}

// MARK: - DriverSettings ViewModel
class DriverSettingsViewModel {
    
    var settings: [DriverSettingsOptionViewModel]
    
    init() {
        settings = [ DriverNameSettingVM(),      // Name
                    DriverTypeSettingVM(),      // Type
                    DriverPayRateSettingVM() ]   // Pay rate
    }
    
    //TODO: Fetch/Save data in CoreData
    func updateName(with name: String) { }
    
    func updateTeamStatus(with isTeam: Bool ) { }
    
    func updatePayRate(with payRate: Int) {  }
}


// MARK: - DriverSettingsOption ViewModels
// Name
class DriverNameSettingVM: DriverSettingsOptionViewModel {
    var type: DriverSettingsType = .name
    var image: UIImage? = SFSymbols.personIdCard
    var title: String = "Name"
    
    //TODO: Fetch/Assign in CoreData
    var name: String?
}

// Type
class DriverTypeSettingVM: DriverSettingsOptionViewModel {
    var type: DriverSettingsType = .driverType
    var image: UIImage? = SFSymbols.personTwo
    var title: String = "Type"
    
    // TODO: Fetch/Save in CoreData
    var isTeamDriver: Bool { return false }
}

// Pay rate
class DriverPayRateSettingVM: DriverSettingsOptionViewModel {
    var type: DriverSettingsType = .payRate
    var image: UIImage? = SFSymbols.percent
    var title: String = "of Total Gross"
    
    // TODO: Fetch/Save in CoreData
    var payRate: Int { return 88 }
}
