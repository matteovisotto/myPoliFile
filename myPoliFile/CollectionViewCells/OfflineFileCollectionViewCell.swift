//
//  OfflineFileCollectionViewCell.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import Foundation
import UIKit

class OfflineFileCollectionViewCell: UICollectionViewCell {
    var file: OfflineFile! {
        didSet {
            fileName.text = file.fileName
            fileInfo.text = String(format: NSLocalizedString("file.documenttype", comment: "Document type"), file.fileExtension)
            if let fileImage = UIImage(named: file.fileExtension) {
                imageView.image = fileImage
            } else {
                imageView.image = UIImage(named: "default")
            }
        }
    }
    
    private let imageView = UIImageView()
    private let fileName = UILabel()
    private let fileInfo = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .secondarySystemGroupedBackground
        } else {
            backgroundColor = .white
        }
        setupImageView()
        setupFileName()
        setupFileInfo()
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
    
    private func setupFileName() {
        addSubview(fileName)
        fileName.translatesAutoresizingMaskIntoConstraints = false
        fileName.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        fileName.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        fileName.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        fileName.font = .systemFont(ofSize: 17)
        fileName.numberOfLines = .zero
    }
    
    private func setupFileInfo() {
        addSubview(fileInfo)
        fileInfo.translatesAutoresizingMaskIntoConstraints = false
        fileInfo.topAnchor.constraint(equalTo: fileName.bottomAnchor, constant: 10).isActive = true
        fileInfo.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        fileInfo.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        fileInfo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        fileInfo.heightAnchor.constraint(equalToConstant: self.frame.height/4).isActive = true
        fileInfo.font = .systemFont(ofSize: 15)
        if #available(iOS 13.0, *) {
            fileInfo.textColor = .secondaryLabel
        } else {
            fileInfo.textColor = .lightGray
        }
    }
}
