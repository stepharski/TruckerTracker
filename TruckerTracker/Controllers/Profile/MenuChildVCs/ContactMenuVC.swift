//
//  ContactMenuVC.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 12/26/22.
//

import UIKit

// Sections
private enum SectionType: String, CaseIterable {
    case email, message
    
    var title: String {
        return "Your \(self.rawValue)"
    }
    
    var subtitle: String {
        switch self {
        case .email:
            return "so we can get back to you"
        case .message:
            return "tell us what's on your mind"
        }
    }
}

// ContactMenuVC
class ContactMenuVC: UIViewController {
    
    let tableView = UITableView()
    let sendButton = TRButton(title: "SEND", type: .light)
    
    private let sections = SectionType.allCases
    

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        configureTableView()
        configureSendButton()
    }
    
    // UI
    private func layoutUI() {
        view.addSubviews(tableView, sendButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            sendButton.heightAnchor.constraint(equalToConstant: 45),
            sendButton.widthAnchor.constraint(equalToConstant: 200),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding / 2),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding / 2),
            tableView.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -padding)
        ])
    }
    
    // Configuration
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.alwaysBounceVertical = false
        
        tableView.register(ContactCell.nib, forCellReuseIdentifier: ContactCell.identifier)
    }
    
    private func configureSendButton() {
        sendButton.dropShadow(color: .white.withAlphaComponent(0.25))
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    @objc private func sendButtonPressed() { }
}

// MARK: - UITableViewDelegate
extension ContactMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .email:
            return 130
        case .message:
            return 240
        }
    }
}

// MARK: - UITableViewDataSource
extension ContactMenuVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath)
                                                                                        as! ContactCell
        let currentSection = sections[indexPath.section]
        cell.title = currentSection.title
        cell.subtitle = currentSection.subtitle
        
        cell.textFieldDidChange = { text in
            print(text)
        }
        
        return cell
    }
}
