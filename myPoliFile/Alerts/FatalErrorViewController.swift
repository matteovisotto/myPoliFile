//
//  FatalErrorViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import UIKit

class FatalErrorViewController: BaseViewController {

    private let imageView = UIImageView(image: UIImage(named: "errorIcon"))
    private let textLabel = UILabel()
    private let detailLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    

    private func setupLayout() {
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(textLabel)
        textLabel.text = NSLocalizedString("global.fatalerror", comment: "Fatal error")
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        textLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -25).isActive = true
        textLabel.textAlignment = .center
        textLabel.font = .boldSystemFont(ofSize: 40)
        textLabel.textColor = secondaryLabelColor
        
        self.view.addSubview(detailLabel)
        detailLabel.text = NSLocalizedString("error.unablestart", comment: "Unable to start")
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15).isActive = true
        detailLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25).isActive = true
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = .zero
        detailLabel.font = .boldSystemFont(ofSize: 25)
        detailLabel.textColor = secondaryLabelColor
    }

}
