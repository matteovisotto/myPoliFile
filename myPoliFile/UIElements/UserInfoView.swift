//
//  UserInfoView.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

class UserInfoView: UIView {
    
    private let imageView = UIImageView()
    private let fullnameLabel = UILabel()
    private let emailLabel = UILabel()
    
    private var secondaryLabelColor: UIColor {
        var c = UIColor.darkGray
        if #available(iOS 13.0, *) {
            c = UIColor.secondaryLabel
        }
        return c
    }
    
    private var imageRadius: CGFloat = 65
    
    open var profileImage: UIImage = UIImage(named: "userGeneric") ?? UIImage() {
        didSet{
            self.imageView.image = profileImage
        }
    }
    
    open var fullname: String = "" {
        didSet {
            self.fullnameLabel.text = fullname
        }
    }
    
    open var email: String = "" {
        didSet {
            self.emailLabel.text = email
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: imageRadius*2).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageRadius*2).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageRadius
        imageView.image = profileImage
        
        self.addSubview(fullnameLabel)
        fullnameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullnameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        fullnameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        fullnameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        fullnameLabel.font = .boldSystemFont(ofSize: 25)
        fullnameLabel.textAlignment = .center
        
        self.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 10).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        emailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        emailLabel.font = .systemFont(ofSize: 18)
        emailLabel.textColor = secondaryLabelColor
        emailLabel.textAlignment = .center
    }
}
