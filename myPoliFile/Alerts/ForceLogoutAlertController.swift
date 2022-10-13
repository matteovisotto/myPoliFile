//
//  ForceLogoutAlertController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 29/09/21.
//

import Foundation
import UIKit

class ForceLogoutAlertController: AlertViewController {
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let confirmButton = AppButton()
    
    private var completion: ()->() = {}
    
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
        
        alertView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        messageLabel.numberOfLines = .zero
        
        alertView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10).isActive = true
        confirmButton.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        confirmButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        confirmButton.setTitle("OK", for: .normal)
        
        confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
    }
    
    func setAlert(title: String, message: String, completionHandler: @escaping ()->()) -> Void {
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.completion = completionHandler
    }
    
    
    @objc private func didTapConfirm() {
        self.completion()
    }
    
}
