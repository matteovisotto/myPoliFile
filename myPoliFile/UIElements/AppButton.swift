//
//  GreenButton.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class AppButton: UIButton {
    
    
    public var normalColor: UIColor = .buttonPrimary {
        didSet{
            backgroundColor = normalColor
        }
    }
    public var highlightedColor: UIColor = .buttonSecondary
    public var normalTextColor: UIColor = .white {
        didSet{
            setTitleColor(normalTextColor, for: .normal)
        }
    }
    public var highlightedTextColor: UIColor = .white
    

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedColor : normalColor
            setTitleColor(isHighlighted ? highlightedTextColor : normalTextColor, for: .normal)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? normalColor : normalColor.withAlphaComponent(0.5)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = normalColor
        setTitleColor(normalTextColor, for: .normal)
        layer.cornerRadius = 10
        contentEdgeInsets = UIEdgeInsets(top: 10,left: 15,bottom: 10,right: 15)
        titleLabel?.font = .boldSystemFont(ofSize: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

