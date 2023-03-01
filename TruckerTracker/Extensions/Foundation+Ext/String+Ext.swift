//
//  String+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 1/20/23.
//

import Foundation

extension String {
    
    func camelCaseToWords() -> String {
        return unicodeScalars.dropFirst().reduce(String(prefix(1))) {
            return CharacterSet.uppercaseLetters.contains($1)
                ? $0 + " " + String($1)
                : $0 + String($1)
        }
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
