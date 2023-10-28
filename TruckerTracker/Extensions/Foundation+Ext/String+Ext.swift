//
//  String+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/20/23.
//

import Foundation

extension String {
    
    func hasContent() -> Bool {
        return !self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    func camelCaseToWords() -> String {
        return self.replacingOccurrences(of: "([A-Z])",
                                         with: " $1",
                                         options: .regularExpression,
                                         range: range(of: self))
                                                .lowercased()
                                                .capitalizeFirstWord()
    }
    
    func capitalizeFirstWord() -> String {
        guard let firstCharacter = self.first else { return self }
        
        return String(firstCharacter).uppercased() + dropFirst()
    }
    
    
    func count(of subString: String) -> Int {
        return self.components(separatedBy: subString).count - 1
    }
    
    
    func numberOfCharacters(after subString: String) -> Int {
        guard let range = self.range(of: subString) else {
            return 0
        }
        
        return self.distance(from: range.upperBound, to: self.endIndex)
    }
}
