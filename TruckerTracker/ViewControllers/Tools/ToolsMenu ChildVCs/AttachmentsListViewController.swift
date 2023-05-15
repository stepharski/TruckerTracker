//
//  AttachmentsListViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/15/23.
//

import UIKit

class AttachmentsListViewController: UIViewController {
    
    let xPadding: CGFloat = 15
    
    private let sortFilterStackView = UIStackView()
    private let sortButton = SortFilterButton(type: .sort)
    private let filterButton = SortFilterButton(type: .filter)
    
    private let tableView = UITableView()
    private let addButton = TRButton()

    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        configureSortFilterStack()
        configureSortFilterButtons()
        configureTableView()
        configureAddButton()
    }

    
    // Layout UI
    private func layoutUI() {
        [sortFilterStackView, tableView, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let bottomMultiplier: CGFloat = DeviceTypes.isiPhoneSE ? 1 : 2
        NSLayoutConstraint.activate([
            sortFilterStackView.heightAnchor.constraint(equalToConstant: 50),
            sortFilterStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            sortFilterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            sortFilterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xPadding),
            
            addButton.heightAnchor.constraint(equalToConstant: 45),
            addButton.widthAnchor.constraint(equalToConstant: 200),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15*bottomMultiplier),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xPadding),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -15),
            tableView.topAnchor.constraint(equalTo: sortFilterStackView.bottomAnchor, constant: 20)
        ])
        
    }
    
    // Configure
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ToolsAttachmentCell.nib, forCellReuseIdentifier: ToolsAttachmentCell.identifier)
    }
    
    private func configureSortFilterStack() {
        sortFilterStackView.spacing = 20
        sortFilterStackView.axis = .horizontal
        sortFilterStackView.distribution = .fillEqually
        sortFilterStackView.addArrangedSubview(sortButton)
        sortFilterStackView.addArrangedSubview(filterButton)
    }
    
    private func configureSortFilterButtons() {
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    private func configureAddButton() {
        addButton.set(title: "ADD", action: .confirm, shape: .capsule)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // Sort/Filter
    @objc func sortButtonTapped() {
        //TODO: Show SortVC
    }
    
    @objc func filterButtonTapped() {
        //TODO: Show FilterVC
    }
    
    // Add Attachment
    @objc func addButtonTapped() {
        //TODO: Show NewItemVC ???
    }
}

// MARK: - UITableView Delegate
extension AttachmentsListViewController: UITableViewDelegate {
    // Row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 + 15
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Handle selection
    }
}

// MARK: - UITableView DataSource
extension AttachmentsListViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ToolsAttachmentCell.identifier) as! ToolsAttachmentCell
        
        return cell
    }
}
