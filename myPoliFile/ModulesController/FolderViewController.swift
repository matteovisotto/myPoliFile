//
//  FolderViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import UIKit

class FolderViewController: BaseViewController {
    
    open var module: Module! {
        didSet{
            self.folderModule = module as! ModuleFolder
        }
    }
    
    private var folderModule: ModuleFolder = ModuleFolder()
    private var navigationBar = BackHeader()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
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
        navigationBar.titleLabel.text = "Detail"
    }
    
    @objc private func didTapBack() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}
