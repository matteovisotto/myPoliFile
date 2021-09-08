//
//  GreenButton.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class AppButton: UIButton {
    
    public var normalColor: UIColor = #colorLiteral(red: 0.386259675, green: 0.7774221301, blue: 0.6624203324, alpha: 1) //#5BC8A8
    public var highlightedColor: UIColor = #colorLiteral(red: 0.07058823529, green: 0.06274509804, blue: 0.3215686275, alpha: 1) //#121052
    public var normalTextColor: UIColor = .white
    public var highlightedTextColor: UIColor = .white
    

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedColor : normalColor
            setTitleColor(isHighlighted ? highlightedTextColor : normalTextColor, for: .normal)
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

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
