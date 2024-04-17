//
//  OnBoardingViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/27/24.
//

import Foundation

// MARK: - OnBoardingViewModel
class OnBoardingViewModel {
    // MARK: Variables
    var isTeam = false
    var earningPercent = 88
    private let dataManager = CoreDataManager.shared

    // MARK: Save User
    func saveNewUser() {
        print("Save New User")
//        UDManager.shared.isFirstLaunch = false
//        UDManager.shared.userSinceDate = .now.local.startOfDay
        // TODO: Save User to Code Data
    }
}
