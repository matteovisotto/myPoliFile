//
//  TitleDescriptionButton.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 20/09/21.
//

import Foundation
import UIKit

class TitleDescriptionButton: UIButton {
    
    enum DividerPosition {
        case top
        case bottom
        case none
    }
    
    private let titleLabel1 = UILabel()
    private let descriptionLabel1 = UILabel()
    
    private var rightImageView: UIImageView = {
       let i = UIImageView(image: UIImage(named: "rightIndicator")!)
        i.contentMode = .scaleAspectFit
        if #available(iOS 13.0, *) {
            i.tintColor = .secondaryLabel
        } else {
            i.tintColor = .lightGray
        }
        return i
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected{
                if #available(iOS 13.0, *) {
                    self.backgroundColor = .label.withAlphaComponent(0.1)
                } else {
                    self.backgroundColor = .black.withAlphaComponent(0.1)
                }
            } else {
                self.backgroundColor = .clear
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted{
                if #available(iOS 13.0, *) {
                    self.backgroundColor = .label.withAlphaComponent(0.1)
                } else {
                    self.backgroundColor = .black.withAlphaComponent(0.1)
                }
            } else {
                self.backgroundColor = .clear
            }
        }
    }
    
    open var titleText: String = "" {
        didSet {
            titleLabel1.text = titleText
        }
    }
    
    open var descriptionText: String = "" {
        didSet {
            descriptionLabel1.text = descriptionText
        }
    }
    
    open var hasDividerAtPosition: DividerPosition = .none {
        didSet {
            addDivider(at: hasDividerAtPosition)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(rightImageView)
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        rightImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        rightImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(titleLabel1)
        titleLabel1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel1.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        titleLabel1.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        titleLabel1.rightAnchor.constraint(equalTo: rightImageView.leftAnchor, constant: -5).isActive = true
        titleLabel1.font = .boldSystemFont(ofSize: 18)
        
        addSubview(descriptionLabel1)
        descriptionLabel1.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel1.topAnchor.constraint(equalTo: titleLabel1.bottomAnchor, constant: 5).isActive = true
        descriptionLabel1.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        descriptionLabel1.rightAnchor.constraint(equalTo: rightImageView.leftAnchor, constant: -5).isActive = true
        descriptionLabel1.font = .systemFont(ofSize: 14)
        descriptionLabel1.numberOfLines = .zero
        if #available(iOS 13.0, *) {
            descriptionLabel1.textColor = .secondaryLabel
        } else {
            descriptionLabel1.textColor = .darkGray
        }
        descriptionLabel1.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addDivider(at position: DividerPosition) {
        let v = UIView()
        if #available(iOS 13.0, *) {
            v.backgroundColor = .secondaryLabel
        } else {
            v.backgroundColor = .lightGray
        }
        if(position == .top) {
            addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            v.heightAnchor.constraint(equalToConstant: 0.6).isActive = true
            v.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
            v.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
            v.topAnchor.constraint(equalTo: topAnchor, constant: -5).isActive = true
        } else if (position == .bottom){
            addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            v.heightAnchor.constraint(equalToConstant: 0.6).isActive = true
            v.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
            v.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
            v.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5).isActive = true
        }
    }
}
