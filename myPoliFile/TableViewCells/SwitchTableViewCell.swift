//
//  SwitchTableViewCell.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 12/09/21.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    open var switchStatus: Bool = false {
        didSet{
            switchControl.isOn = switchStatus
        }
    }
    
    open var text: String = "" {
        didSet{
            label.text = text
        }
    }

    var switchControl = UISwitch()
    private var label = UILabel()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if #available(iOS 13.0, *) {
            self.backgroundColor = .secondarySystemGroupedBackground
        } else {
            self.backgroundColor = .white
        }
        self.selectionStyle = .none
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(switchControl)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
        switchControl.onTintColor = .buttonPrimary
    }
    
    
}
