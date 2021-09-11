//
//  ViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class WelcomeViewController: BaseViewController {
    
    private let startButton = AppButton()
    private let personalCodeTF = FloatingTextField()
    private let welcomeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addWelcomeLabel()
        addStartButton()
        addTextField()
    }
    
    private func addWelcomeLabel() {
        self.view.addSubview(welcomeLabel)
        welcomeLabel.text = "Welcome \nto myPoliFile"
        welcomeLabel.numberOfLines = .zero
        welcomeLabel.textColor = .primary
        welcomeLabel.font = .systemFont(ofSize: 40, weight: .black)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
    }
    
    private func addStartButton() {
        self.view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        startButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        startButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        startButton.setTitle("Login with PoliMi", for: .normal)
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        startButton.isEnabled = false
    }
    
    private func addTextField() {
        self.view.addSubview(personalCodeTF)
        personalCodeTF.translatesAutoresizingMaskIntoConstraints = false
        personalCodeTF.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        personalCodeTF.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        personalCodeTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        personalCodeTF.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        personalCodeTF._placeholder = "PoliMi Personal Code"
        personalCodeTF.keyboardType = .numberPad
        personalCodeTF.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        
    }
    
    @objc private func didTapStartButton() {
        PreferenceManager.setPersonalCode(personalCode: self.personalCodeTF.text!)
        User.mySelf.username = self.personalCodeTF.text! + "@polimi.it"
        let loginVC = WebLoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
        loginVC.callback = { content in
            if let data = content.data(using: .utf8) {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                    if let token = dic?["token"] {
                        self.startButton.isHidden = true
                        self.personalCodeTF.isHidden = true
                        self.welcomeLabel.isHidden = true
                        PreferenceManager.setToken(token: token)
                        User.mySelf.token = token
                        let loadignVC = LoadingViewController()
                        loadignVC.modalPresentationStyle = .fullScreen
                        self.present(loadignVC, animated: true, completion: nil)
                    } else {
                        let errorVC = ErrorAlertController()
                        errorVC.setContent(title: "Error", message: "Unable to find your personal token. Please check from the webpage if the access key is configured")
                        errorVC.modalPresentationStyle = .overFullScreen
                        self.present(errorVC, animated: true, completion: nil)
                    }
                } catch {
                    let errorVC = ErrorAlertController()
                    errorVC.setContent(title: "Error", message: error.localizedDescription)
                    errorVC.modalPresentationStyle = .overFullScreen
                    self.present(errorVC, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @objc private func didTextFieldChanged() {
        if(self.personalCodeTF.text?.count == 8 && self.personalCodeTF.text!.isNumeric) {
            self.startButton.isEnabled = true
        } else {
            self.startButton.isEnabled = false
        }
    }
    
}

