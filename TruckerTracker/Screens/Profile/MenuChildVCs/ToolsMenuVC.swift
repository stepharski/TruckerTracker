//
//  ToolsMenuVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/9/22.
//

import UIKit

// Tools definition
private enum ToolType: String {
    case units, currency, weekStartsOn
    
    var title: String {
        switch self {
        case .weekStartsOn:
            return "Week starts on"
        default:
            return self.rawValue.capitalized
        }
    }
}

private enum ToolItemType: String {
    case imperial, metric
    case usd, euro
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var title: String {
        switch self {
        case .usd, .euro:
            return self.rawValue.uppercased()
        default:
            return self.rawValue.capitalized
        }
    }
}

private struct Tool {
    var type: ToolType
    var items: [ToolItemType]
    var selectedItem: ToolItemType
}

// MARK: ToolsMenuVC
class ToolsMenuVC: UIViewController {
    
    let tableView = UITableView()
    let resetButton = TRButton(title: "RESET", type: .dark)
    
    private var tools = [Tool]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        configureTools()
        configureTableView()
        configureResetButton()
    }
    
    
    private func configureTools() {
        tools = [
            Tool(type: .units,
                 items: [.imperial, .metric],
                 selectedItem: .imperial),
            Tool(type: .currency,
                 items: [.usd, .euro],
                 selectedItem: .usd),
            Tool(type: .weekStartsOn,
                 items: [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday],
                 selectedItem: .monday)
        ]
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = .clear
        
        tableView.register(TRItemCell.nib, forCellReuseIdentifier: TRItemCell.identifier)
    }
    
    private func configureResetButton() {
        resetButton.dropShadow()
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    @objc func resetButtonTapped() { }
    
    
    private func layoutUI() {
        view.addSubviews(tableView, resetButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 200),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding / 2),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding / 2),
            tableView.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -padding)
        ])
    }
    
    // Navigation
    private func showPickerVC(for tool: Tool) {
        guard let selectedRow = tool.items.firstIndex(of: tool.selectedItem) else {
            return
        }
        
        var pickerItems = [String]()
        tool.items.forEach { pickerItems.append($0.title) }
        
        let pickerVC = TRPickerVC(pickerItems: pickerItems, selectedRow: selectedRow)
        pickerVC.modalPresentationStyle = .overCurrentContext
        pickerVC.modalTransitionStyle = .coverVertical
        pickerVC.delegate = self

        present(pickerVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ToolsMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TRItemCell.identifier, for: indexPath) as! TRItemCell
        
        let tool = tools[indexPath.row]
        
        cell.itemName = tool.type.title
        cell.itemValue = tool.selectedItem.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPickerVC(for: tools[indexPath.row])
    }
}

// MARK: - TRPickerDelegate
extension ToolsMenuVC: TRPickerDelegate {
    func didSelectItem(name: String) {
        print(name)
    }
}
