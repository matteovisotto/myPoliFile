//
//  FileOptionBottomSheet.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import UIKit

class FileOptionBottomSheet: BaseViewController {

    var alertView = UIView()
    private var cancelButton = UIButton()
    private var openButton = AppButton()
    private var downloadButton = AppButton()
    private let divider = UIView()
    
    var completion: (_ result: Bool, _ option: Int?)->() = {_,_ in }
    
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
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        alertView.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true
        divider.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 5).isActive = true
        divider.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -5).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.backgroundColor = secondaryLabelColor
        
        alertView.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -10).isActive = true
        downloadButton.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        downloadButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        downloadButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.addTarget(self, action: #selector(didTapDownload), for: .touchUpInside)
        
        alertView.addSubview(openButton)
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -10).isActive = true
        openButton.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        openButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        openButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        openButton.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        openButton.setTitle("Open", for: .normal)
        openButton.addTarget(self, action: #selector(didTapOpen), for: .touchUpInside)
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
        completion(false, nil)
    }
    
    @objc private func didTapOpen() {
        self.dismiss(animated: true, completion: nil)
        completion(true, 0)
    }
    
    @objc private func didTapDownload() {
        self.dismiss(animated: true, completion: nil)
        completion(true, 1)
    }

}
