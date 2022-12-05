//
//  ProfileMenuType.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 11/14/22.
//

import UIKit

enum ProfileMenuType: String, CaseIterable {
    
    case tools, driver, documents,
         recurring, data, contact
    
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
        case .documents:
            return SFSymbols.folder
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
        case .documents:
            return "Manage uploaded files \n grouped by type"
        case .recurring:
            return "Schedule or edit \n transactions that repeat"
        case .data:
            return "Synchronize \n your information"
        case .contact:
            return "Provide feedback \n report bug or ask question"
        }
    }
}
