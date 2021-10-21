//
//  FeedbackAlert.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 20/09/21.
//

import Foundation
import UIKit

class FeedbackAlert: UIViewController {
    
    private var backgroundView: UIView!
    private var imageView: UIImageView!
    private var textLabel: UILabel!
    
    private var text: String = ""
    private var image: UIImage = UIImage()
    private var dismissTime: Double = 1.0
    
    public func setText(title: String) {
        self.text = title
    }
    
    public func setIcon(icon: UIImage) {
        self.image = icon
    }
    
    public func setDismissTime(timeInterval: Double) {
        self.dismissTime = timeInterval
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.backgroundView = createBackgroundView()
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.imageView = createImageView()
        self.backgroundView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        imageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        
        self.textLabel = createLabel()
        backgroundView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20).isActive=true
        textLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 20).isActive = true
        textLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -20).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Close the alert after interval
        let _ = Timer.scheduledTimer(withTimeInterval: dismissTime, repeats: false) { timer in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func createBackgroundView() -> UIView {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = self.image
        if #available(iOS 13.0, *) {
            imageView.tintColor = UIColor.label
        } else {
            imageView.tintColor = .black
        }
        imageView.contentMode = .scaleToFill
        return imageView
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.text = self.text
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }
    
}

