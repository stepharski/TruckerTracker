//
//  Constants.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 8/28/22.
//

import UIKit

// MARK: Constants
enum Constants {
    static let minimumDaysInFirstWeek: Int = 4
}

// MARK: AppColors
enum AppColors {
    // FIXME: Change to HEX
    static let textColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)
    static let headerColors = [#colorLiteral(red: 0.1843137255, green: 0.6, blue: 0.4274509804, alpha: 1), #colorLiteral(red: 0.1098039216, green: 0.1568627451, blue: 0.1411764706, alpha: 1)]
    static let negativeIncomeColors = [#colorLiteral(red: 0.7450980392, green: 0.1333333333, blue: 0.07843137255, alpha: 1), #colorLiteral(red: 0.2549019608, green: 0.0431372549, blue: 0.02352941176, alpha: 1)]
}

// MARK: StoryboardIdentifiers
enum StoryboardIdentifiers {
    static let mainStoryboard = "Main"
    static let onBoardingStoryboard = "OnBoarding"
    static let onBoardingController = "OnBoardingViewController"
    static let tabBarController = "TRTabBarController"
    static let dashboardViewController = "DashboardViewController"
    static let itemEntryViewController = "ItemEntryViewController"
    static let toolsViewController = "ToolsViewController"
    static let toolMenuViewController = "ToolMenuViewController"
}

// MARK: SFSymbols
enum SFSymbols {
    // Navigation
    static let xmark = UIImage(systemName: "xmark")
    static let arrowBack = UIImage(systemName: "chevron.backward")
    static let chartLine = UIImage(systemName: "chart.xyaxis.line")
    static let squareArrowUp = UIImage(systemName: "square.and.arrow.up")
    
    // TabBar
    static let listRect = UIImage(systemName: "list.bullet.below.rectangle")
    static let plus = UIImage(systemName: "plus")
    static let wrenchScrew = UIImage(systemName: "wrench.and.screwdriver")
    
    // TableView
    static let plusRectangleFill = UIImage(systemName: "plus.rectangle.fill")
    static let questionmarkBubble = UIImage(systemName: "questionmark.bubble.fill")
    static let docTextMagGlass = UIImage(systemName: "doc.text.magnifyingglass")
    
    // TextField
    static let checkmark = UIImage(systemName: "checkmark")
    
    // Expense
    static let scribble = UIImage(systemName: "scribble")
    static let walletPass = UIImage(systemName: "wallet.pass")
    
    // Frequency
    static let repeatArrows = UIImage(systemName: "repeat")
    static let creditCard = UIImage(systemName: "creditcard")
    
    // Load
    static let shippingBox = UIImage(systemName: "shippingbox")
    
    // Miles
    static let roadLanes = UIImage(systemName: "road.lanes")
    static let roadLanesEmpty = UIImage(systemName: "road.lane.arrowtriangle.2.inward")
    
    // Fuel
    static let fuelPumpFill = UIImage(systemName: "fuelpump.fill")
    static let dropFill = UIImage(systemName: "drop.fill")
    static let snowflake = UIImage(systemName: "snowflake")
    
    // Tools
    static let wrench = UIImage(systemName: "wrench.adjustable")
    static let personText = UIImage(systemName: "person.text.rectangle")
    static let docOnDoc = UIImage(systemName: "doc.on.doc")
    static let crownArrow = UIImage(systemName: "digitalcrown.arrow.clockwise")
    static let trash = UIImage(systemName: "trash")
    static let envelope = UIImage(systemName: "envelope")
    
    // App Settings
    static let gearArrows = UIImage(systemName: "gearshape.arrow.triangle.2.circlepath")
    static let steeringWheel = UIImage(systemName: "steeringwheel")
    static let banknote = UIImage(systemName: "banknote")
    static let calendar = UIImage(systemName: "calendar")
    static let moon = UIImage(systemName: "moon")
    
    // Driver Settings
    static let personIdCard = UIImage(systemName: "person.text.rectangle")
    static let personTwo = UIImage(systemName: "person.2")
    static let percent = UIImage(systemName: "percent.ar")
    
    // Attachments
    static let docFill = UIImage(systemName: "doc.fill")
    
    // Sort/Filter
    static let arrowUpDown = UIImage(systemName: "arrow.up.arrow.down")
    static let linesDown = UIImage(systemName: "line.3.horizontal.decrease")
    
    // Compact arrows
    static let arrowCompactUp = UIImage(systemName: "chevron.compact.up")
    static let arrowCompactDown = UIImage(systemName: "chevron.compact.down")
    static let arrowCompactLeft = UIImage(systemName: "chevron.compact.left")
    static let arrowCompactRight = UIImage(systemName: "chevron.compact.right")
    
    // Sync benefits
    static let macStudio = UIImage(systemName: "macstudio")
    static let macPro = UIImage(systemName: "macpro.gen1")
}

// MARK: ScreenSize
enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}

// MARK: DeviceTypes
enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale
    
    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhoneZoomed           = idiom == .phone && nativeScale > scale
}

