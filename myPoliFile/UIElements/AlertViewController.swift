//
//  AlertViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class AlertViewController: BaseViewController {

    var alertView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = labelColor.withAlphaComponent(0.4)
        setupLayout()
    }
    
    private func setupLayout() {
        alertView.backgroundColor = backgroundColor
        self.view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: getWidth()).isActive = true
        alertView.layer.cornerRadius = 15
    }
    
    private func getWidth() -> CGFloat {
        var width: CGFloat = 300
        if(self.view.bounds.width <= 300){
            width = self.view.bounds.width - 40
        }
        return width
    }
    
}
