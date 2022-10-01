//
//  Constants.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/28/22.
//

import UIKit

enum SFSymbols {
    static let menu = UIImage(systemName: "line.3.horizontal")
    static let share = UIImage(systemName: "square.and.arrow.up")
    static let circleLine = UIImage(systemName: "circle.and.line.horizontal")
    static let circleLineFilled = UIImage(systemName: "circle.and.line.horizontal.fill")
    static let plus = UIImage(systemName: "plus")
    static let person = UIImage(systemName: "person")
    static let personFill = UIImage(systemName: "person.fill")

    static let dollar = UIImage(systemName: "dollarsign.circle")
    static let dollarFilled = UIImage(systemName: "dollarsign.circle.fill")
    static let doubleCircle = UIImage(systemName: "circle.circle")
    static let doubleCircleFilled = UIImage(systemName: "circle.circle.fill")
    static let minusCircle = UIImage(systemName: "minus.circle")
    static let minusCircleFilled = UIImage(systemName: "minus.circle.fill")
    static let flame = UIImage(systemName: "flame")
    static let flameFilled = UIImage(systemName: "flame.fill")
}


enum StoryboardIdentifiers {
    static let trackerNavigationController = "TrackerNavigationController"
    static let newItemNavigationController = "NewItemNavigationController"
    static let profileNavigationController = "ProfileNavigationController"
    static let trackerCategoryVC = "TrackerCategoryVC"
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

