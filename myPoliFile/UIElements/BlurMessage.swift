//
//  BlurMessage.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 25/10/21.
//

import Foundation
import UIKit

class BlurMessage: UIView {
    
    open var message: String = "" {
        didSet{
            label.text = message
        }
    }
    
    private var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createBlurView()
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBlurView() {
        var blurStyle = UIBlurEffect.Style.dark
        if #available(iOS 13.0, *) {
            blurStyle = .systemUltraThinMaterialDark
        }
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blurEffectView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        blurEffectView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: blurEffectView.topAnchor, constant: 3).isActive = true
        label.leftAnchor.constraint(equalTo: blurEffectView.leftAnchor, constant: 5).isActive = true
        label.rightAnchor.constraint(equalTo: blurEffectView.rightAnchor, constant: -5).isActive = true
        label.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor, constant: -3).isActive = true
        label.textColor = .white
        label.textAlignment = .center
        
    }
    
}
