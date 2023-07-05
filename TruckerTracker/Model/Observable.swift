//
//  Observable.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 7/4/23.
//

import Foundation

final class Observable<T> {
    
    var value: T {
        didSet { listener?(value) }
    }
    
    private var listener: ((T) -> Void)?
    
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping(T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
