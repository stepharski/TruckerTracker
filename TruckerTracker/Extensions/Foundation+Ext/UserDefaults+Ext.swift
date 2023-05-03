//
//  UserDefaults+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/24/23.
//

import Foundation

extension UserDefaults {
    
    func setCodable<Element: Codable>(value: Element, forKey key: String) {
        let data = try? JSONEncoder().encode(value)
        UserDefaults.standard.setValue(data, forKey: key)
    }
    
    func codableValue<Element: Codable>(forKey key: String) -> Element? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let element = try? JSONDecoder().decode(Element.self, from: data)
        return element
    }
}
