//
//  TagView.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

class TagView: UIView {
    
    private let label = UILabel()
    
    open var text: String = "" {
        didSet {
            label.text = text.uppercased()
        }
    }
    
    open var textColor: UIColor = .black {
        didSet{
            label.textColor = textColor
        }
    }
    
    open var color: UIColor = .clear {
        didSet{
            backgroundColor = color.withAlphaComponent(0.5)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    
    private func setupLayout() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: self.frame.height/2).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -self.frame.height/2).isActive = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .black)
    }
    
}
