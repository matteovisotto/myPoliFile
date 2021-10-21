//
//  HomeHeader.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

class HomeHeader: UIView {
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    
    public let settingsButton = SquareImageButton()
    public let notificationButton = SquareImageButton()
    
    open var logoImage: UIImage = UIImage() {
        didSet {
            logoImageView.image = logoImage
        }
    }
    
    open var headerTitle: String = "" {
        didSet {
            titleLabel.text = headerTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtons() {
        addSubview(settingsButton)
        addSubview(notificationButton)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        settingsButton.rightAnchor.constraint(equalTo:rightAnchor, constant: -10).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        settingsButton.layer.cornerRadius = 11
        settingsButton.layer.masksToBounds = true
        settingsButton.btnImage = UIImage(named: "gear")!
        
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        notificationButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        notificationButton.rightAnchor.constraint(equalTo: settingsButton.leftAnchor, constant: -5).isActive = true
        notificationButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        notificationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        notificationButton.layer.cornerRadius = 11
        notificationButton.layer.masksToBounds = true
        notificationButton.btnImage = UIImage(named: "bell")!
        
    }
    
    private func setupTitle() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: notificationButton.leftAnchor, constant: -10).isActive = true
        notificationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
    }
    
}
