//
//  OnBoardingSlide.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/16/24.
//

import Foundation

enum OnBoardingSlide: Int, CaseIterable {
    case howdy
    case drivingMode
    case earnings

    var buttonTitle: String {
        switch self {
        case .howdy: return "Start \nEngine"
        case .drivingMode: return "Release \nBrakes"
        case .earnings: return "Hit Gas"
        }
    }
}
