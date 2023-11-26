//
//  FeedbackViewController.swift
//  TruckerTracker
//
//  Created by Stepan Kukharskyi on 5/29/23.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let messageTextView = MessageTextView()
    private let sendButton = ActionButton()
    
    var message: String?

    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
        configureSendButton()
        configureTitleLabel()
        configureSubtitleLabel()
        configureContainerView()
        configureMessageTextView()
        registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterFromKeyboardNotifications()
    }
    
    
    // Layout
    private func layoutUI() {
        view.addSubviews(containerView, sendButton)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let containerHeight: CGFloat = 0.5 * view.bounds.height
        let bottomMultiplier: CGFloat = DeviceTypes.isiPhoneSE ? 1 : 2
        NSLayoutConstraint.activate([
            sendButton.heightAnchor.constraint(equalToConstant: 45),
            sendButton.widthAnchor.constraint(equalToConstant: 200),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15*bottomMultiplier),
            
            containerView.heightAnchor.constraint(equalToConstant: containerHeight),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // Configuration
    private func configureContainerView() {
        containerView.roundEdges(by: 15)
        containerView.dropShadow(opacity: 0.1)
        containerView.backgroundColor = .systemGray6
        
        [titleLabel, subtitleLabel, messageTextView].forEach {
            containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            
            messageTextView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 15),
            messageTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            messageTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    // Labels
    private func configureTitleLabel() {
        // TODO: Create custom reusable TRLabel
        titleLabel.text = "Your message"
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    private func configureSubtitleLabel() {
        subtitleLabel.text = "drop us a line, we're all ears"
        subtitleLabel.textColor = .label
        subtitleLabel.textAlignment = .left
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    // TextField
    private func configureMessageTextView() {
        messageTextView.delegate = self
        messageTextView.roundEdges(by: 10)
        messageTextView.backgroundColor = .systemGray5
    }
    
    // Send Button
    private func configureSendButton() {
        sendButton.set(title: "SEND", action: .confirm, shape: .capsule)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    // Send functionality
    @objc private func sendButtonTapped() {
        //TODO: Send message using SendGrid
    }
    
    // Notifications
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                           name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                           name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                                      as? NSValue)?.cgRectValue else { return }
        
        
        let keyboardTop = view.frame.height - keyboardSize.height
        let textViewBottom = messageTextView.frame.origin.y + messageTextView.frame.height
        let insetAdjustment = max(0, textViewBottom - keyboardTop)
        messageTextView.updateBottomInset(with: insetAdjustment)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        messageTextView.updateBottomInset(with: 0)
    }
}

// MARK: - UITextView Delegate
extension FeedbackViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        message = textView.text
    }
}
