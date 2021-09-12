//
//  SegmentTableViewCell.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import UIKit

class SegmentTableViewCell: UITableViewCell {
    
    var segmentedControl = UISegmentedControl(items: ["Open", "Download", "Ask"])
    open var selectedIndex: Int  = 0 {
        didSet{
            segmentedControl.selectedSegmentIndex = selectedIndex
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupSegmented()
    }
    
    private func setupSegmented() {
        self.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = .primaryBackground
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBackground], for: UIControl.State.selected)
        } else {
            segmentedControl.tintColor = .primaryBackground
            segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        }
        
    }

}
