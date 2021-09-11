//
//  SectionTitleCollectionReusableView.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import UIKit

class SectionTitleCollectionReusableView: UICollectionReusableView {
    private let label = UILabel()
    
    open var sectionTitle: String = "" {
        didSet{
            self.label.text = sectionTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .primary
    }
}
