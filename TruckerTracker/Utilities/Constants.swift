//
//  Constants.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/28/22.
//

import UIKit

enum SFSymbols {
    
    // Navigation
    static let menu = UIImage(systemName: "line.3.horizontal")
    static let share = UIImage(systemName: "square.and.arrow.up")
    static let xmark = UIImage(systemName: "xmark")
    static let arrowBack = UIImage(systemName: "chevron.backward")
    
    // TabBar
    static let circleLine = UIImage(systemName: "circle.and.line.horizontal")
    static let circleLineFill = UIImage(systemName: "circle.and.line.horizontal.fill")
    static let plus = UIImage(systemName: "plus")
    static let person = UIImage(systemName: "person")
    static let personFill = UIImage(systemName: "person.fill")

    // Categories
    static let dollar = UIImage(systemName: "dollarsign.circle")
    static let minusCircle = UIImage(systemName: "minus.circle")
    static let speedometer = UIImage(systemName: "speedometer")
    static let fuelPumpCircle = UIImage(systemName: "fuelpump.circle")
    
    static let plusSquares = UIImage(systemName: "plus.square.on.square")
    static let docPlus = UIImage(systemName: "doc.fill.badge.plus")

    
    // Profile
    static let wrenchScrew = UIImage(systemName: "wrench.and.screwdriver")
    static let personText = UIImage(systemName: "person.text.rectangle")
    static let folder = UIImage(systemName: "folder")
    static let crownArrow = UIImage(systemName: "digitalcrown.arrow.clockwise")
    static let chartBarX = UIImage(systemName: "chart.bar.xaxis")
    static let envelope = UIImage(systemName: "envelope")
    static let pc = UIImage(systemName: "pc")
    
    // Compact arrows
    static let arrowCompactUp = UIImage(systemName: "chevron.compact.up")
    static let arrowCompactDown = UIImage(systemName: "chevron.compact.down")
    static let arrowCompactLeft = UIImage(systemName: "chevron.compact.left")
    static let arrowCompactRight = UIImage(systemName: "chevron.compact.right")
}



enum StoryboardIdentifiers {
    static let tabBarController = "TRTabBarController"
    static let trackerVC = "TrackerVC"
    static let categorySummaryVC = "CategorySummaryVC"
    static let profileVC = "ProfileVC"
    static let menuDetailedVC = "MenuDetailedVC"
    static let categoryItemVC = "CategoryItemVC"
    static let locationSearchVC = "LocationSearchVC"
}


enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}


enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale
    
    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhoneZoomed           = idiom == .phone && nativeScale > scale
}

