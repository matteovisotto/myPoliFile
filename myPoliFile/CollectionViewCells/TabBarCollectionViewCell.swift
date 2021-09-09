//
//  TabBarCollectionViewCell.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    private let bar = UIView()
    
    private var secondary: UIColor {
        var c = UIColor.darkGray
        if #available(iOS 13.0, *) {
            c = UIColor.secondaryLabel
        }
        return c
    }
    
    override var isSelected: Bool {
        didSet{
            imageView.tintColor = isSelected ? .primary : secondary
            bar.backgroundColor = isSelected ? .primary : .clear
        }
    }
    
    open var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 2.5).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = secondary
        
        addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3).isActive = true
        bar.widthAnchor.constraint(equalToConstant: frame.width*(2/3)).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 2).isActive = true
        bar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.5).isActive = true
        bar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
}
