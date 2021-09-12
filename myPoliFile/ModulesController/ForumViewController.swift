//
//  ForumViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import UIKit

class ForumViewController: BaseViewController {
    
    private var navigationBar = BackHeader()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        let errorLabel = UILabel()
        self.view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.numberOfLines = .zero
        errorLabel.text = "Forum functions will be available in the next release"
        if #available(iOS 13.0, *) {
            errorLabel.textColor = .secondaryLabel
        } else {
            errorLabel.textColor = .darkGray
        }
        errorLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        errorLabel.textAlignment = .center
    }
    
    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = .clear
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }

    @objc private func didTapBack() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}
