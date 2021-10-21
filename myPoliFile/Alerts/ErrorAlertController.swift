//
//  ErrorAlertController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class ErrorAlertController: AlertViewController {
    
    private let titleLabel = UILabel()
    private let messageLable = UILabel()
    private let dismissButton = UIButton()

    private var alertTitle: String = ""
    private var alertMessage: String = ""
    
    open var isLoadingPhase = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        alertView.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        dismissButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        dismissButton.setImage(UIImage(named: "cross"), for: .normal)
        dismissButton.imageView?.tintColor = labelColor
        dismissButton.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        
        
        alertView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 15).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 15).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -15).isActive = true
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.textAlignment = .center
        titleLabel.text = self.alertTitle
        
        alertView.addSubview(messageLable)
        messageLable.translatesAutoresizingMaskIntoConstraints = false
        messageLable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        messageLable.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 15).isActive = true
        messageLable.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -15).isActive = true
        messageLable.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -15).isActive = true
        messageLable.numberOfLines = .zero
        messageLable.text = self.alertMessage
        
        
    }
    
    public func setContent(title: String?, message: String) {
        self.alertTitle = title ?? ""
        self.alertMessage = message
    }
    
    @objc private func didTapDismiss() {
        if isLoadingPhase {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = appDelegate.window
            window?.rootViewController = FatalErrorViewController()
            window?.makeKeyAndVisible()
            
        }
        self.dismiss(animated: true, completion: nil)
    }

}
