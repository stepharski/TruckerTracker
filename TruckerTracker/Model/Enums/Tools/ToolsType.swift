//
//  ToolsType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/14/23.
//

import UIKit

enum ToolsType: String, CaseIterable {
    
    case settings, driver
    case attachments, recurring
    case reset, cloud
    
    var title: String {
        return self.rawValue.capitalized
    }
    
    var subtitle: String {
        switch self {
        case .settings:
            return "App configuration"
        case .driver:
            return "Personal info"
        case .attachments:
            return "Uploaded attachments"
        case .recurring:
            return "Scheduled expenses"
        case .cloud:
            return "Secure your data"
        case .reset:
            return "Start from scratch"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .settings:
            return SFSymbols.wrench
        case .driver:
            return SFSymbols.personText
        case .attachments:
            return SFSymbols.docOnDoc
        case .recurring:
            return SFSymbols.crownArrow
        case .cloud:
            return SFSymbols.cloud
        case .reset:
            return SFSymbols.trash
        }
    }
    
    var description: String {
        switch self {
        case .settings:
            return "Configure app \n appearance and workflow"
        case .driver:
            return "Edit driver's \n personal info and type"
        case .attachments:
            return "Manage uploaded files \n grouped by type"
        case .recurring:
            return "Schedule or edit \n expenses that repeat"
        case .cloud:
            return "Keep your data secure \n in the cloud"
        case .reset:
            return "Erase your existing data \n to begin anew"
        }
    }
}
