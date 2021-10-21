//
//  SquareImageButton.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

class SquareImageButton: UIButton {
    
    private let btnImageView = UIImageView()
    open var btnImage: UIImage = UIImage() {
        didSet {
            btnImageView.image = btnImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageView()
        setLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImageView() {
        self.addSubview(btnImageView)
        btnImageView.translatesAutoresizingMaskIntoConstraints = false
        btnImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        btnImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        btnImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        btnImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        btnImageView.contentMode = .scaleAspectFit
        if #available(iOS 13.0, *) {
            btnImageView.tintColor = .secondaryLabel
        } else {
            btnImageView.tintColor = .darkGray
        }
    }
    
    private func setLayout() {
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
}
