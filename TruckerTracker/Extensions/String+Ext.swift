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
}
