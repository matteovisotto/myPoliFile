//
//  GenericCollectionViewCell.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import UIKit

class GenericCollectionViewCell: UICollectionViewCell {
    open var text: String = "" {
        didSet{
            label.text = text
        }
    }
    
    private var textColor: UIColor  {
        if #available(iOS 13.0, *){
            return .secondaryLabel
        }
        return .darkGray
    }
    
    private let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.textColor = textColor
        label.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
