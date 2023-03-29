//
//  UITableView+Ext.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/29/23.
//

import UIKit

extension UITableView {
    
    func setEmptyView(title: String, message: String) {
        let emptyView = EmptyStateView(title: title, message: message)
        emptyView.frame = self.frame
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
