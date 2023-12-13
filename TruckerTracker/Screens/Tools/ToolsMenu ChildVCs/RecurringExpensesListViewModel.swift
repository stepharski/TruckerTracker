//
//  RecurringExpensesListViewModel.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/22/23.
//

import UIKit

//MARK: - Recurring Expenses List
class RecurringExpensesListViewModel {
    
    private var recurringExpenseViewModels = [RecurringExpenseViewModel]()
    
    var numberOfRows: Int {
        return recurringExpenseViewModels.count
    }
    
    func model(at index: Int) -> RecurringExpenseViewModel {
        return recurringExpenseViewModels[index]
    }
    
    func fetchRecurringExpenses() {
        //TODO: Fetch from Core Data
//        for _ in 0..<15 {
//            let expense = Expense.getRecurringMock()
//            guard expense.frequency != .oneTime else { return }
//            
//            let expenseVM = RecurringExpenseViewModel(expense: expense)
//            recurringExpenseViewModels.append(expenseVM)
//        }
    }
}


//MARK: - Recurring Expense
class RecurringExpenseViewModel {
    
    let expense: Expense
    
    init(expense: Expense) {
        self.expense = expense
    }
    
    var image: UIImage? {
        return SFSymbols.repeatArrows
    }
    
    var title: String {
        return expense.name
    }
    
    var subtitle: String {
        let frequency = expense.frequency

        if frequency == .day {
            return frequency.title
        } else if frequency == .week {
            return "\(frequency.title), \(expense.date.weekdayName())"
        } else {
            return "\(frequency.title), Day \(expense.date.dayNumberInYear())"
        }
    }
    
    var amountText: String {
        let currencySymbol = UDManager.shared.currency.symbol
        let roundedAmount = Int(expense.amount)
        
        return "\(currencySymbol)\(roundedAmount)"
    }
}
