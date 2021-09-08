//
//  ViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class WelcomeViewController: BaseViewController {
    
    private let startButton = AppButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        addStartButton()
        
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
    }
    
    @objc private func didTapStartButton() {
        let loginVC = WebLoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
        loginVC.callback = { content in
            if let data = content.data(using: .utf8) {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                    if let token = dic?["token"] {
                        //PreferenceManager.setToken(token: token)
                        User.mySelf.token = token
                        let x = LoadingViewController()
                        x.modalPresentationStyle = .fullScreen
                        self.present(x, animated: true, completion: nil)
                    } else {
                        //Show error
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

       
    
}

