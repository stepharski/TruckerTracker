//
//  Constants.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/28/22.
//

import UIKit

struct Constants {
    static let minimumDaysInFirstWeek: Int = 4
}

struct AppColors {
    static let textColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    static let headerColors = [#colorLiteral(red: 0.1843137255, green: 0.6, blue: 0.4274509804, alpha: 1), #colorLiteral(red: 0.1098039216, green: 0.1568627451, blue: 0.1411764706, alpha: 1)]
    static let negativeIncomeColors = [#colorLiteral(red: 0.7450980392, green: 0.1333333333, blue: 0.07843137255, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.0431372549, blue: 0.02352941176, alpha: 1)]
}

struct SFSymbols {
    
    // Navigation
    static let menu = UIImage(systemName: "line.3.horizontal")
    static let share = UIImage(systemName: "square.and.arrow.up")
    static let xmark = UIImage(systemName: "xmark")
    static let arrowBack = UIImage(systemName: "chevron.backward")
    
    // TabBar
    static let house = UIImage(systemName: "house")
    static let houseFill = UIImage(systemName: "house.fill")
    static let plus = UIImage(systemName: "plus")
    static let person = UIImage(systemName: "person")
    static let personFill = UIImage(systemName: "person.fill")
    
    // Frequency
    static let repeatArrows = UIImage(systemName: "repeat")
    static let creditCard = UIImage(systemName: "creditcard")
    
    // Miles
    static let roadLanes = UIImage(systemName: "road.lanes")
    static let roadLanesEmpty = UIImage(systemName: "road.lane.arrowtriangle.2.inward")
    
    // Fuel
    static let fuelPumpFill = UIImage(systemName: "fuelpump.fill")
    static let dropFill = UIImage(systemName: "drop.fill")
    
    
    // Categories
    static let dollarCircle = UIImage(systemName: "dollarsign.circle")
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
    
    // Sync benefits
    static let macStudio = UIImage(systemName: "macstudio")
    static let macPro = UIImage(systemName: "macpro.gen1")
}



struct StoryboardIdentifiers {
    static let tabBarController = "TRTabBarController"
    static let homeViewController = "HomeViewController"
    static let itemViewController = "ItemViewController"
    static let profileVC = "ProfileVC"
    static let menuDetailedVC = "MenuDetailedVC"
    
    static let locationSearchVC = "LocationSearchVC"
}


struct ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}


struct DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale
    
    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhoneZoomed           = idiom == .phone && nativeScale > scale
}

