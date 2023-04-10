//
//  SettingsType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 4/9/23.
//

import UIKit

enum SettingsType: String, CaseIterable {
    
    case tools, driver, attachments
    case recurring, data, contact
    
    var title: String {
        return self.rawValue.capitalized
    }
    
    var subtitle: String {
        switch self {
        case .tools:
            return "App configuration"
        case .driver:
            return "Personal info"
        case .attachments:
            return "Uploaded attachments"
        case .recurring:
            return "Scheduled expenses"
        case .data:
            return "Export or Reset"
        case .contact:
            return "Get in touch with us"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .tools:
            return SFSymbols.wrenchScrew
        case .driver:
            return SFSymbols.personText
        case .attachments:
            return SFSymbols.docOnDoc
        case .recurring:
            return SFSymbols.crownArrow
        case .data:
            return SFSymbols.pc
        case .contact:
            return SFSymbols.envelope
        }
    }
    
    var description: String {
        switch self {
        case .tools:
            return "Configure app \n appearance and workflow"
        case .driver:
            return "Edit driver's \n personal info and type"
        case .attachments:
            return "Manage uploaded files \n grouped by type"
        case .recurring:
            return "Schedule or edit \n expenses that repeat"
        case .data:
            return "Synchronize \n your information"
        case .contact:
            return "Provide feedback \n report bug or ask question"
        }
    }
}

