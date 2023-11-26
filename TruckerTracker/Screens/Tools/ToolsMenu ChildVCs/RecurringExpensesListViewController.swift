//
//  RecurringExpensesListViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/22/23.
//

import UIKit

class RecurringExpensesListViewController: UIViewController {
    
    let xPadding: CGFloat = 15
    
    private let sortButton = SortFilterButton(type: .sort)
    private let tableView = UITableView()
    private let addButton = ActionButton()
    
    let viewModel = RecurringExpensesListViewModel()
    

    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
        configureSortButton()
        configureTableView()
        configureAddButton()
        fetchData()
    }
    
    // Layout UI
    private func layoutUI() {
        view.addSubviews(sortButton, tableView, addButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomMultiplier: CGFloat = DeviceTypes.isiPhoneSE ? 1 : 2
        NSLayoutConstraint.activate([
            sortButton.heightAnchor.constraint(equalToConstant: 50),
            sortButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            sortButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xPadding),
            
            addButton.heightAnchor.constraint(equalToConstant: 45),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15*bottomMultiplier),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xPadding),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -15),
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20)
        ])
    }
    
    // Configure
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(RecurringExpenseCell.nib, forCellReuseIdentifier: RecurringExpenseCell.identifier)
    }

    private func configureSortButton() {
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    
    private func configureAddButton() {
        addButton.set(title: "ADD", action: .confirm, shape: .capsule)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // Functionality
    @objc func sortButtonTapped() {
        showSortViewController()
    }
    
    @objc func addButtonTapped() {
        //TODO: Show NewExpense
    }
    
    func fetchData() {
        viewModel.fetchRecurringExpenses()
        tableView.reloadData()
    }
    
    // Navigation
    func showSortViewController() {
        let sortController = SortOptionsViewController()
        sortController.delegate = self
        present(sortController, animated: true)
    }
}

// MARK: - SortOption Selector Delegate
extension RecurringExpensesListViewController: SortOptionSelectorDelegate {
    func sortOptionSelected(_ option: SortOption) {
        //TODO: Fetch data
    }
}

// MARK: - UITableView Delegate
extension RecurringExpensesListViewController: UITableViewDelegate {
    // Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 + 10
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Handle selection
    }
}

// MARK: - UITableView DataSource
extension RecurringExpensesListViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecurringExpenseCell.identifier)
                                                                    as! RecurringExpenseCell
        let model = viewModel.model(at: indexPath.row)
        cell.configure(image: model.image, title: model.title,
                       subtitle: model.subtitle, amountText: model.amountText)
        return cell
    }
}
