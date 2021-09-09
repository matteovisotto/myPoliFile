//
//  SearchViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import UIKit

class SearchViewController: BaseViewController {
    
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupSearchBar()
    }
    

    private func setupSearchBar() {
        searchBar.searchBarStyle = .minimal
        self.view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        searchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        searchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
    }

}
