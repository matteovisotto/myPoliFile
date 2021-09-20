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
    private var openButton = TitleDescriptionButton()
    private var downloadButton = TitleDescriptionButton()
    
    private var alertTitle: UILabel = {
       let l = UILabel()
        l.text = "File action"
        l.font = .boldSystemFont(ofSize: 20)
        return l
    }()
    
    private lazy var alertDescription: UILabel = {
       var l = UILabel()
        l.text = "Please, select an action for this file"
        l.textColor = secondaryLabelColor
        return l
    }()
    
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
        alertView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        alertView.layer.cornerRadius = 15
        alertView.addSubview(alertTitle)
        alertTitle.translatesAutoresizingMaskIntoConstraints = false
        alertTitle.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        alertTitle.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        alertTitle.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        
        alertView.addSubview(alertDescription)
        alertDescription.translatesAutoresizingMaskIntoConstraints = false
        alertDescription.topAnchor.constraint(equalTo: alertTitle.bottomAnchor, constant: 5).isActive = true
        alertDescription.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        alertDescription.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        alertDescription.numberOfLines = .zero
    }
    
    private func setupButtons() {
                
        alertView.addSubview(downloadButton)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        downloadButton.leftAnchor.constraint(equalTo: alertView.leftAnchor).isActive = true
        downloadButton.rightAnchor.constraint(equalTo: alertView.rightAnchor).isActive = true
        downloadButton.addTarget(self, action: #selector(didTapDownload), for: .touchUpInside)
        downloadButton.titleText = "Download"
        downloadButton.descriptionText = "Directly download file in your device"
        
        alertView.addSubview(openButton)
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -10).isActive = true
        openButton.leftAnchor.constraint(equalTo: alertView.leftAnchor).isActive = true
        openButton.rightAnchor.constraint(equalTo: alertView.rightAnchor).isActive = true
        openButton.topAnchor.constraint(equalTo: alertDescription.bottomAnchor, constant: 20).isActive = true
        openButton.addTarget(self, action: #selector(didTapOpen), for: .touchUpInside)
        openButton.titleText = "Open"
        openButton.descriptionText = "Directly open a file preview in the app. A further download is possible"
        openButton.hasDividerAtPosition = .bottom
        
        alertView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        cancelButton.setImage(UIImage(named: "cross")!, for: .normal)
        cancelButton.imageView?.tintColor = secondaryLabelColor
        cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
    }
    
    private func getWidth() -> CGFloat {
        var width: CGFloat = 400
        if(self.view.bounds.width <= 400){
            width = self.view.bounds.width
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
