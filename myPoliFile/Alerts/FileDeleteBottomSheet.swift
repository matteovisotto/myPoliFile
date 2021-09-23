//
//  FileDeleteBottomSheet.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 13/09/21.
//

import Foundation
import UIKit

class FileDeleteBottomSheet: BaseViewController {
    
    var alertView = UIView()
    private var cancelButton = UIButton()
    private var deleteButton = AppButton()
    private let divider = UIView()
    private let titleLable = UILabel()
    private let descriptionLabel = UILabel()
        
    var completion: (_ result: Bool)->() = {_ in }
    
    var alertTitle: String = "" {
        didSet{
            titleLable.text = alertTitle
        }
    }
    
    var alertDescription: String = "" {
        didSet{
            descriptionLabel.text = alertDescription
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = labelColor.withAlphaComponent(0.4)
        setupLayout()
        setupButtons()
    }
    

    private func setupLayout() {
        alertView.backgroundColor = backgroundColor
        self.view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: getWidth()).isActive = true
        alertView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        alertView.layer.cornerRadius = 15
    }
    
    private func setupButtons() {
        alertView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.setTitle(NSLocalizedString("global.cancel", comment: "Cancel"), for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        alertView.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true
        divider.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 5).isActive = true
        divider.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -5).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.backgroundColor = secondaryLabelColor
        
        alertView.addSubview(deleteButton)
        deleteButton.normalColor = .systemRed
        deleteButton.highlightedColor = .systemOrange
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -10).isActive = true
        deleteButton.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        deleteButton.setTitle(NSLocalizedString("global.delete", comment: "Delete"), for: .normal)
        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        
        alertView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -10).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        descriptionLabel.numberOfLines = .zero
        descriptionLabel.textAlignment = .center
        
        alertView.addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10).isActive = true
        titleLable.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        titleLable.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        titleLable.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        titleLable.numberOfLines = .zero
        titleLable.textAlignment = .center
        titleLable.font = .boldSystemFont(ofSize: 20)
        
    }
    
    private func getWidth() -> CGFloat {
        var width: CGFloat = 300
        if(self.view.bounds.width <= 300){
            width = self.view.bounds.width - 40
        }
        return width
    }
    
    @objc private func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
        completion(false)
    }
    
    @objc private func didTapDelete() {
        self.dismiss(animated: true, completion: nil)
        completion(true)
    }

}
