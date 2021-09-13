//
//  OfflineFolderCollectionViewCell.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 13/09/21.
//

import Foundation
import UIKit

class OfflineFolderCollectionViewCell: UICollectionViewCell {
    open var folder: OfflineFolder! {
        didSet {
            nameLabel.text = folder.folderName
        }
    }
    
    private var nameLabel = UILabel()
    private var imageView = UIImageView(image: UIImage(named: "folder")!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .secondarySystemGroupedBackground
        } else {
            backgroundColor = .white
        }
        setupImageView()
        setupNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        imageView.contentMode = .scaleAspectFit
        
    }
    
    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        nameLabel.font = .systemFont(ofSize: 17)
        nameLabel.numberOfLines = .zero
    }
    
}
