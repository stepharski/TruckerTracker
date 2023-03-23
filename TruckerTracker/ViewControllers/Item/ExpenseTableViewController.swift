//
//  ExpenseTableViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 3/23/23.
//

import UIKit

class ExpenseTableViewController: UITableViewController {

    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    // Configuration
    func configure() {
        view.backgroundColor = .systemGray5
    }

    // MARK: - Data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
