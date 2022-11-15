//
//  ProfileMenuType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/14/22.
//

import UIKit

enum ProfileMenuType: String, CaseIterable {
    
    case tools, driver, documents,
         recurring, data, visuals
    
    var title: String {
        return self.rawValue.capitalized
    }
    
    var subtitle: String {
        switch self {
        case .tools:
            return "App configuration"
        case .driver:
            return "Personal info"
        case .documents:
            return "Uploaded documents"
        case .recurring:
            return "Scheduled transactions"
        case .data:
            return "Export or Reset"
        case .visuals:
            return "Charts and Widgets"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .tools:
            return SFSymbols.wrenchScrew
        case .driver:
            return SFSymbols.personText
        case .documents:
            return SFSymbols.folder
        case .recurring:
            return SFSymbols.crownArrow
        case .data:
            return SFSymbols.pc
        case .visuals:
            return SFSymbols.chartBarX
        }
    }
}
