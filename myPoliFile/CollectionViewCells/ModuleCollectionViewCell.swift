//
//  ModuleCollectionViewCell.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import UIKit

class ModuleCollectionViewCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    
    open var moduleName: String = "" {
        didSet {
            self.nameLabel.text = moduleName
        }
    }
    
    open var moduleImage: UIImage = UIImage() {
        didSet{
            self.imageView.image = moduleImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            self.backgroundColor = .secondarySystemGroupedBackground
        } else {
            self.backgroundColor = .white
        }
        setupImageView()
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 45).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        
    }
    
    private func setupLabel() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        nameLabel.numberOfLines = .zero
    }
    
}
