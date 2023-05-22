//
//  Attachment.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/15/23.
//

import Foundation

class Attachment {
    
    let id: String
    let date: Date
    let title: String
    let itemType: ItemType
    
    init(id: String, date: Date, title: String, itemType: ItemType) {
        self.id = id
        self.date = date
        self.title = title
        self.itemType = itemType
    }
    
    static func getRandomMock() -> Attachment {
        let id = UUID().uuidString
        let date = Date()
        let title = "Attachment\(id)"
        let itemType = ItemType.allCases.randomElement() ?? .load
        
        return Attachment(id: id, date: date, title: title, itemType: itemType)
    }
}
