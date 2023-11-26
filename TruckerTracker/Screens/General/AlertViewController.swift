//
//  AlertViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/2/23.
//

import UIKit

class AlertViewController: UIViewController {
    
    var alertTitle: String?
    var message: String?
    
    var cancelTitle: String?
    var actionTitle: String?
    var actionType: ActionButtonType?
    var didTapAction: (() -> Void)?
    
    let xPadding: CGFloat = 30

    let containerView = UIView()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let buttonsStackView = UIStackView()
    
    
    // Life cycle
    init(title: String?, message: String,
         actionTitle: String? = nil, actionType: ActionButtonType? = nil, cancelTitle: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertTitle = title
        self.message = message
        self.actionType = actionType
        self.actionTitle = actionTitle
        self.cancelTitle = cancelTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackground()
        configureContainer()
        configureTitle()
        configureButtons()
        configureMessage()
    }

    // Configuration
    func configureBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }
    
    // Container
    func configureContainer() {
        view.addSubview(containerView)
        containerView.layer.cornerRadius = 15
        containerView.backgroundColor = .systemBackground
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 225),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xPadding)
        ])
    }
    
    // Title
    func configureTitle() {
        view.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.text = alertTitle ?? "Something went wrong"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: xPadding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -xPadding)
        ])
    }
    
    // Message
    func configureMessage() {
        view.addSubview(messageLabel)
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: xPadding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -xPadding),
            messageLabel.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -10)
        ])
    }

    // Buttons
    func configureButtons() {
        configureCancelButton()
        configureActionButton()
        configureButtonsStackView()
    }
    
    // Action button
    func configureActionButton() {
        let actionButton = ActionButton(title: actionTitle ?? "Ok",
                                    action: actionType ?? .confirm, shape: .rectangle)
        buttonsStackView.addArrangedSubview(actionButton)
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {
        didTapAction?()
        self.dismiss(animated: true)
    }
    
    // Cancel button
    func configureCancelButton() {
        guard let title = cancelTitle else { return }
        
        let cancelButton = ActionButton(title: title, action: .cancel, shape: .rectangle)
        buttonsStackView.addArrangedSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    // Buttons stack
    func configureButtonsStackView() {
        buttonsStackView.spacing = xPadding
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        
        view.addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.heightAnchor.constraint(equalToConstant: 45),
            buttonsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: xPadding),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -xPadding)
        ])
    }
}
