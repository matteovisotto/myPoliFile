//
//  ViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class WelcomeViewController: BaseViewController {
    
    private let poliMiButton = AppButton()
    private let tokenButton = UIButton()
    private let personalCodeTF = FloatingTextField()
    private let welcomeLabel = UILabel()
    private var model: WelcomeViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = WelcomeViewModel(target: self)
        addWelcomeLabel()
        addStartButton()
        addTextField()
    }
    
    private func addWelcomeLabel() {
        self.view.addSubview(welcomeLabel)
        welcomeLabel.text = NSLocalizedString("welcome.welcome", comment: "Welcome \nto myPoliFile")
        welcomeLabel.numberOfLines = .zero
        welcomeLabel.textColor = .primary
        welcomeLabel.font = .systemFont(ofSize: 40, weight: .black)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
    }
    
    private func addStartButton() {
        self.view.addSubview(tokenButton)
        tokenButton.translatesAutoresizingMaskIntoConstraints = false
        tokenButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        tokenButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        tokenButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        tokenButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        tokenButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        tokenButton.setTitle(NSLocalizedString("welcome.tokenlogin", comment: "Token Login"), for: .normal)
        tokenButton.setTitleColor(.primary, for: .normal)
        tokenButton.addTarget(self, action: #selector(didTapTokenButton), for: .touchUpInside)
        tokenButton.isEnabled = false
        
        let divider = DividerView()
        self.view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.bottomAnchor.constraint(equalTo: tokenButton.topAnchor, constant: 5).isActive = true
        divider.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        divider.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(poliMiButton)
        poliMiButton.translatesAutoresizingMaskIntoConstraints = false
        poliMiButton.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -5).isActive = true
        poliMiButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        poliMiButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        poliMiButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        poliMiButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        poliMiButton.setTitle(NSLocalizedString("welcome.polimilogin", comment: "PoliMi Login"), for: .normal)
        poliMiButton.addTarget(self, action: #selector(didTapPoliMiButton), for: .touchUpInside)
        poliMiButton.isEnabled = false
    }
    
    private func addTextField() {
        self.view.addSubview(personalCodeTF)
        personalCodeTF.translatesAutoresizingMaskIntoConstraints = false
        personalCodeTF.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        personalCodeTF.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        personalCodeTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        personalCodeTF.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        personalCodeTF._placeholder = NSLocalizedString("welcome.personalcode", comment: "Personal Code")
        personalCodeTF.keyboardType = .numberPad
        personalCodeTF.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        
    }
    
    @objc private func didTapPoliMiButton() {
        model.performActionForPoliMiLogin(usingPersonalCode: self.personalCodeTF.text!)
    }
    
    @objc private func didTextFieldChanged() {
        if(self.personalCodeTF.text?.count == 8 && self.personalCodeTF.text!.isNumeric) {
            self.poliMiButton.isEnabled = true
            self.tokenButton.isEnabled = true
        } else {
            self.poliMiButton.isEnabled = false
            self.tokenButton.isEnabled = false
        }
    }
    
    @objc private func didTapTokenButton() {
        model.performActionForTokenLogin(usingPersonalCode: self.personalCodeTF.text!)
    }
}

