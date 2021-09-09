//
//  BackHeader.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

class BackHeader: UIView {
    var titleLabel = UILabel()
    var backButton = UIButton()
    
    private var labelColor: UIColor {
        var c = UIColor.black
        if #available(iOS 13.0, *){
            c = UIColor.label
        }
        return c
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        backButton.setImage(UIImage(named: "arrowBack"), for: .normal)
        backButton.imageView?.tintColor = labelColor
        backButton.imageView?.contentMode = .scaleAspectFit
        
        addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true //25
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
