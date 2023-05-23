//
//  SortOptionsViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/22/23.
//

import UIKit

// MARK: - SortOption Selector Delegate
protocol SortOptionSelectorDelegate: AnyObject {
    func sortOptionSelected(_ option: SortOption)
}

// MARK: - SortOption Type
enum SortOption: String, CaseIterable {
    case nameAToZ
    case nameZToA
    case amountLowToHigh
    case amountHighToLow
    case dateNewestToOldest
    case dateOldestToNewest
    
    var title: String {
        switch self {
        case .nameAToZ:
            return "Name: A to Z"
        case .nameZToA:
            return "Name: Z to A"
        case .amountLowToHigh:
            return "Amount: Low to High"
        case .amountHighToLow:
            return "Amount: High to Low"
        case .dateNewestToOldest:
            return "Date: Newest to Oldest"
        case .dateOldestToNewest:
            return "Date: Oldest to Newest"
        }
    }
}

// MARK: - SortOptions ViewController
class SortOptionsViewController: UIViewController {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private let tableView = UITableView()
    private let applyButton = TRButton()
    
    private let options = SortOption.allCases
    
    var selectedOption: SortOption = .dateNewestToOldest {
        didSet { tableView.reloadData() }
    }
    
    weak var delegate: SortOptionSelectorDelegate?

    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureContainerView()
        
        layoutUI()
        configureTitleLabel()
        configureCloseButton()
        configureTableView()
        configureApplyButton()
    }

    // Dismiss on background tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first else { return }

        let location = touch.location(in: view)
        if !containerView.frame.contains(location) {
            self.dismiss(animated: true)
        }
    }

    // Container View
    private func configureContainerView() {
        view.addSubview(containerView)
        containerView.roundEdges(by: 10)
        containerView.backgroundColor = .systemGray6
        
        let minimumHeight: CGFloat = 500
        let computedHeight: CGFloat = 0.65 * view.bounds.height
        let containerHeight: CGFloat = computedHeight < minimumHeight ? minimumHeight
                                                                     : computedHeight
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
    }
    
    // Layout
    private func layoutUI() {
        [titleLabel, closeButton, tableView, applyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            applyButton.widthAnchor.constraint(equalToConstant: 300),
            applyButton.heightAnchor.constraint(equalToConstant: 45),
            applyButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            applyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -25),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    // Configuration
    private func configureTitleLabel() {
        titleLabel.text = "SORT BY"
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    private func configureCloseButton() {
        var config = UIButton.Configuration.plain()
        config.image = SFSymbols.xmark
        config.baseForegroundColor = .label
        closeButton.configuration = config
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        tableView.register(SortOptionCell.nib, forCellReuseIdentifier: SortOptionCell.identifier)
    }
    
    private func configureApplyButton() {
        applyButton.set(title: "APPLY", action: .confirm, shape: .rectangle)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func applyButtonTapped() {
        delegate?.sortOptionSelected(selectedOption)
        self.dismiss(animated: true)
    }
}

// MARK: - UITableView DataSource
extension SortOptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortOptionCell.identifier, for: indexPath) as! SortOptionCell
        
        let option = options[indexPath.row]
        cell.optionTitle = option.title
        cell.isOptionSelected = option == selectedOption
        
        return cell
    }
    
    
}

// MARK: - UITableView Delegate
extension SortOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45 + 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = options[indexPath.row]
    }
}
