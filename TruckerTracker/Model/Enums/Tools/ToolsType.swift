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
    case reset, feedback
    
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
        case .reset:
            return "Start from scratch"
        case .feedback:
            return "Share your thoughts"
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
        case .reset:
            return SFSymbols.trash
        case .feedback:
            return SFSymbols.envelope
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
        case .reset:
            return "Leave the past \n in your rearview"
        case .feedback:
            return "Share your thoughts, \n suggestions or concerns"
        }
    }
}

