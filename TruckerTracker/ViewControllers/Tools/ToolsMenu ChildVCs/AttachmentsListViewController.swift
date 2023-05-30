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
    private let addButton = ActionButton()
    
    let viewModel = AttachmentsListViewModel()
    

    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        configureSortFilterStack()
        configureSortFilterButtons()
        configureTableView()
        configureAddButton()
        fetchData()
    }

    
    // Layout UI
    private func layoutUI() {
        view.addSubviews(sortFilterStackView, tableView, addButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        sortFilterStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    // Functionality
    @objc func sortButtonTapped() {
        showSortViewController()
    }
    
    @objc func filterButtonTapped() {
        showFilterViewController()
    }
    
    @objc func addButtonTapped() {
        //TODO: Show NewItemVC ???
    }
    
    func fetchData() {
        viewModel.fetchAttachments()
        tableView.reloadData()
    }
    
    // Navigation
    func showSortViewController() {
        let sortController = SortOptionsViewController()
        sortController.delegate = self
        present(sortController, animated: true)
    }
    
    func showFilterViewController() {
        let filterController = FilterOptionsViewController()
        filterController.delegate = self
        present(filterController, animated: true)
    }
}

// MARK: - SortOption Selector Delegate
extension AttachmentsListViewController: SortOptionSelectorDelegate {
    func sortOptionSelected(_ option: SortOption) {
        //TODO: Fetch data
    }
}

// MARK: - FilterOptions Selector Delegate
extension AttachmentsListViewController: FilterOptionsSelectorDelegate {
    func filterOptionsSelected(period: Period, categories: Set<ItemType>) {
        //TODO: Fetch data
    }
}

// MARK: - UITableView Delegate
extension AttachmentsListViewController: UITableViewDelegate {
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
extension AttachmentsListViewController: UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToolsAttachmentCell.identifier)
                                                                    as! ToolsAttachmentCell
        let model = viewModel.model(at: indexPath.row)
        cell.configure(image: model.image,
                       title: model.title,
                       subtitle: model.subtitle)
        return cell
    }
}
