//
//  WelcomeIPadViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 24/09/21.
//

import UIKit

class WelcomeIPadViewController: BaseViewController {
    
    private let titleLabel: UILabel = {
       let l = UILabel()
        l.text = NSLocalizedString("welcome.welcome2", comment: "Welcome \nto myPoliFile")
        l.numberOfLines = .zero
        l.textAlignment = .center
        l.textColor = .primary
        l.font = .systemFont(ofSize: 40, weight: .black)
        return l
    }()
    
    
    private let loginButton = AppButton()
    private let tokenButton = UIButton()
    private let personalCode = FloatingTextField()

    private var model: WelcomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = WelcomeViewModel(target: self)
        loginButton.isEnabled = false
        tokenButton.isEnabled = false
        setupUI()
    }
    
    private func setupUI() {
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        let containerView = UIView()
        containerView.backgroundColor = backgroundColor
        containerView.layer.cornerRadius = 10
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        containerView.addSubview(tokenButton)
        tokenButton.translatesAutoresizingMaskIntoConstraints = false
        tokenButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        containerView.addSubview(personalCode)
        personalCode.translatesAutoresizingMaskIntoConstraints = false
        personalCode.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        tokenButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        tokenButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        tokenButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        
        let divider = DividerView()
        containerView.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.bottomAnchor.constraint(equalTo: tokenButton.topAnchor, constant: 5).isActive = true
        divider.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        divider.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        loginButton.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -5).isActive = true
        loginButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        loginButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        
        personalCode.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -60).isActive = true
        personalCode.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        personalCode.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        personalCode.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        personalCode._placeholder = NSLocalizedString("welcome.personalcode", comment: "Personal Code")
        personalCode.keyboardType = .numberPad
        loginButton.setTitle(NSLocalizedString("welcome.polimilogin", comment: "PoliMi Login"), for: .normal)
        tokenButton.setTitle(NSLocalizedString("welcome.tokenlogin", comment: "Token Login"), for: .normal)
        tokenButton.setTitleColor(.primary, for: .normal)
        tokenButton.setTitleColor(.primary.withAlphaComponent(0.5), for: .disabled)
        
        
        personalCode.addTarget(self, action: #selector(textChanges), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        tokenButton.addTarget(self, action: #selector(didTapTokenButton), for: .touchUpInside)
    }
    
    @objc private func textChanges() {
        if(self.personalCode.text?.count == 8 && self.personalCode.text!.isNumeric) {
            self.loginButton.isEnabled = true
            self.tokenButton.isEnabled = true
        } else {
            self.loginButton.isEnabled = false
            self.tokenButton.isEnabled = false
        }
    }
    
    @objc private func didTapLoginButton() {
        model.performActionForPoliMiLogin(usingPersonalCode: self.personalCode.text!)
    }
    
    @objc private func didTapTokenButton() {
        model.performActionForTokenLogin(usingPersonalCode: self.personalCode.text!)
    }

}
