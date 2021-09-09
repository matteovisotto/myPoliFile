//
//  ErrorAlertController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class ErrorAlertController: AlertViewController {
    
    private let titleLable = UILabel()
    private let messageLable = UILabel()
    private let dismissButton = AppButton()

    private var alertTitle: String = ""
    private var alertMessage: String = ""
    
    open var isLoadingPhase = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        alertView.addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        titleLable.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 15).isActive = true
        titleLable.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -15).isActive = true
        titleLable.font = .boldSystemFont(ofSize: 25)
        titleLable.textAlignment = .center
        titleLable.text = self.alertTitle
        
        alertView.addSubview(messageLable)
        messageLable.translatesAutoresizingMaskIntoConstraints = false
        messageLable.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 15).isActive = true
        messageLable.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 15).isActive = true
        messageLable.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -15).isActive = true
        messageLable.numberOfLines = .zero
        messageLable.text = self.alertMessage
        
        alertView.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.topAnchor.constraint(equalTo: messageLable.bottomAnchor, constant: 15).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 15).isActive = true
        dismissButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -15).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10).isActive = true
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        dismissButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    public func setContent(title: String?, message: String) {
        self.alertTitle = title ?? ""
        self.alertMessage = message
    }
    
    @objc private func didTapDismiss() {
        self.dismiss(animated: true, completion: nil)
        if isLoadingPhase {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = appDelegate.window
            window?.rootViewController = FatalErrorViewController()
            window?.makeKeyAndVisible()
            
        }
    }

}
