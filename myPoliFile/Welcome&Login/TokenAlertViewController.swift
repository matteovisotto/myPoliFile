//
//  TokenAlertViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 15/09/21.
//

import UIKit

class TokenAlertViewController: AlertViewController {
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let cancelButton = AppButton()
    private let confirmButton = AppButton()
    private let textArea = UITextView()

    var callback: (_ token: String)->() = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
    }
    
    private func setupLayouts() {
        alertView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.textAlignment = .center
        titleLabel.text = "Token"
        
        alertView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        messageLabel.text = "Please insert your personal mobile token. If you don't have it, login in the website first, then from setting find and copy your security key for mobile servicies"
        messageLabel.numberOfLines = .zero
        
        alertView.addSubview(textArea)
        textArea.translatesAutoresizingMaskIntoConstraints = false
        textArea.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10).isActive = true
        textArea.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        textArea.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        textArea.heightAnchor.constraint(equalToConstant: 88).isActive = true
        textArea.backgroundColor = .groupTableViewBackground
        
        let stackView = UIStackView()
        alertView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: textArea.bottomAnchor, constant: 10).isActive = true
        stackView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 33).isActive = true
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        cancelButton.normalColor = .systemRed
        cancelButton.highlightedColor = .systemOrange
        
        cancelButton.setTitle("Cancel", for: .normal)
        confirmButton.setTitle("Login", for: .normal)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(confirmButton)
        
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    @objc private func didTapCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapLogin() {
        let token = textArea.text ?? ""
        self.dismiss(animated: true, completion: nil)
        callback(token)
    }
    
}
