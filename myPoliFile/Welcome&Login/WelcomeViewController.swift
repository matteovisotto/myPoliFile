//
//  ViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class WelcomeViewController: BaseViewController {
    
    private let startButton = AppButton()
    private let tokenButton = UIButton()
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
        self.view.addSubview(tokenButton)
        tokenButton.translatesAutoresizingMaskIntoConstraints = false
        tokenButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        tokenButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        tokenButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        tokenButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        tokenButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        tokenButton.setTitle("Login with token", for: .normal)
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
        
        self.view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -5).isActive = true
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
            self.tokenButton.isEnabled = true
        } else {
            self.startButton.isEnabled = false
            self.startButton.isEnabled = false
        }
    }
    
    @objc private func didTapTokenButton() {
        PreferenceManager.setPersonalCode(personalCode: self.personalCodeTF.text!)
        User.mySelf.username = self.personalCodeTF.text! + "@polimi.it"
        let tokenVC = TokenAlertViewController()
        tokenVC.modalPresentationStyle = .overFullScreen
        tokenVC.callback = {token in
            PreferenceManager.setToken(token: token)
            User.mySelf.token = token
            let parameter: [String:Any] = ["field":"username", "values[0]":User.mySelf.username]
            let p = LinkBuilder.prepareParameters(params: parameter)
            let url = LinkBuilder.build(serviceName: "core_user_get_users_by_field", withParameters: p)
            let userTask = TaskManager(url: URL(string: url)!)
            userTask.delegate = self
            userTask.execute()
        }
        self.present(tokenVC, animated: true, completion: nil)
    }
}

extension WelcomeViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        if result {
            if let data = stringContent.data(using: .utf8) {
                do {
                    let people = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
                    if let p = people {
                        if (p.count == 1) {
                            let person = p[0] as? [String:Any]
                            if let _ = person {
                                DispatchQueue.main.async {
                                    let loadignVC = LoadingViewController()
                                    loadignVC.modalPresentationStyle = .fullScreen
                                    self.present(loadignVC, animated: true, completion: nil)
                                }
                                return
                            }
                        }
                    }
                } catch {
                    
                }
            }
        }
            //Show error
            PreferenceManager.removeToken()
            PreferenceManager.removePersonalCode()
            DispatchQueue.main.async {
                let errorVC = ErrorAlertController()
                errorVC.isLoadingPhase = false
                errorVC.setContent(title: "Error", message: "Personal code or token wrong")
                errorVC.modalPresentationStyle = .overFullScreen
                self.present(errorVC, animated: true, completion: nil)
            }
        }
    
}
