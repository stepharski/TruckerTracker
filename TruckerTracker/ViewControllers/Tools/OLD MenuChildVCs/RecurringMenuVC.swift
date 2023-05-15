////
////  RecurringMenuVC.swift
////  TruckerTracker
////
////  Created by Stepan Kukharskyi on 12/25/22.
////
//
//import UIKit
//
//// Test data
//private struct RecurringExpense {
//    let name: String
//    let amount: Int
//    let frequency: FrequencyType
//}
//
//// RecurringMenuVC
//class RecurringMenuVC: UIViewController {
//    
//    let tableView = UITableView()
//    let addButton = TRButton(title: "ADD", action: .confirm, shape: .capsule)
//    
//    private var expenses = [RecurringExpense]()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        layoutUI()
//        addTestData()
//        configureTableView()
//        configureAddButton()
//    }
//
//    // Add test data
//    func addTestData() {
//        expenses = [
//            RecurringExpense(name: "ELD", amount: 25, frequency: .day),
//            RecurringExpense(name: "IFTA", amount: 150, frequency: .week),
//            RecurringExpense(name: "Insurance", amount: 420, frequency: .month),
//            RecurringExpense(name: "Truck rental", amount: 808, frequency: .week)
//        ]
//    }
//    
//    // UI
//    func layoutUI() {
//        view.addSubviews(tableView, addButton)
//        
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        let padding: CGFloat = 20
//        NSLayoutConstraint.activate([
//            addButton.heightAnchor.constraint(equalToConstant: 45),
//            addButton.widthAnchor.constraint(equalToConstant: 200),
//            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding),
//            
//            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding / 2),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding / 2),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding / 2),
//            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -padding)
//        ])
//    }
//    
//    // Configuration
//    func configureAddButton() {
//        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
//    }
//    
//    @objc func addButtonPressed() {
//        //TODO: - Show AddExpenseVC
//    }
//    
//    func configureTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.backgroundColor = .clear
//        tableView.register(RecurringExpenseCell.nib, forCellReuseIdentifier: RecurringExpenseCell.identifier)
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension RecurringMenuVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 65
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //TODO: Show ExpenseDetailVC
//    }
//}
//
//// MARK: - UITableViewDataSource
//extension RecurringMenuVC: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return expenses.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: RecurringExpenseCell.identifier, for: indexPath)
//                                                                                    as! RecurringExpenseCell
//        let expense = expenses[indexPath.row]
//        
//        cell.name = expense.name
//        cell.amount = expense.amount
//        cell.frequency = expense.frequency
//        
//        return cell
//    }
//}
