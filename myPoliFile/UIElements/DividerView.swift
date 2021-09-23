//
//  DividerView.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 14/09/21.
//

import Foundation
import UIKit

class DividerView: UIView {
    
    private var secondaryLabelColor: UIColor {
        if #available(iOS 13.0, *){
            return UIColor.secondaryLabel
        } else {
            return UIColor.lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let lb = UILabel()
        lb.text = NSLocalizedString("global.or", comment: "OR")
        lb.textColor = secondaryLabelColor
        lb.textAlignment = .center
        addSubview(lb)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lb.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        lb.widthAnchor.constraint(equalToConstant: 30).isActive = true
        lb.font = .systemFont(ofSize: 14)
        
        let v1 = createFillView()
        addSubview(v1)
        v1.translatesAutoresizingMaskIntoConstraints = false
        v1.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        v1.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        v1.rightAnchor.constraint(equalTo: lb.leftAnchor, constant: -5).isActive = true
        v1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let v2 = createFillView()
        addSubview(v2)
        v2.translatesAutoresizingMaskIntoConstraints = false
        v2.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        v2.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        v2.leftAnchor.constraint(equalTo: lb.rightAnchor, constant: 5).isActive = true
        v2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createFillView() -> UIView {
        let v = UIView()
        v.backgroundColor = secondaryLabelColor
        return v
    }
    
}
