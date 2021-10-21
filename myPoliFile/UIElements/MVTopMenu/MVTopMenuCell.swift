//
//  MVTopMenuCell.swift
//  myListaSpesa
//
//  Created by Matteo Visotto on 16/10/2020.
//  Copyright © 2020 MatMac System. All rights reserved.
//

import UIKit

class MVTopMenuCell: UICollectionViewCell {
    static let cellIdentifier = "mvTopMenuCell"
    
    private let label = UILabel()
    private let bottomView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var labelColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor.black
        }
    }()
    
    private var secondaryLabelColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.secondaryLabel
        } else {
            return UIColor.darkGray
        }
    }()
    
    private var colorBackground: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }()
    
    override var isHighlighted: Bool {
        didSet{
            label.textColor = isHighlighted ? labelColor : secondaryLabelColor
        }
    }
    
    override var isSelected: Bool {
        didSet{
            label.textColor = isSelected ? labelColor : secondaryLabelColor
            bottomView.backgroundColor = isSelected ? labelColor : .clear
        }
    }
    
    private func setupUI() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = secondaryLabelColor
        label.font = .systemFont(ofSize: 15, weight: .semibold)
                
        self.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: topAnchor, constant: self.frame.height-3).isActive = true
        bottomView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomView.backgroundColor = .clear
    }
    
    public func setMenuCell(withTitle title: String) {
        self.label.text = title
    }
}
