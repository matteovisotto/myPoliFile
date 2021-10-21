//
//  FloatingTextField.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import Foundation
import UIKit

class FloatingTextField: UITextField {
    var floatingLabel: UILabel!// = UILabel(frame: CGRect.zero)
    var floatingLabelHeight: CGFloat = 14
    var button = UIButton(type: .custom)
    var imageView = UIImageView(frame: CGRect.zero)
    
    
    var _placeholder: String? {
        didSet{
            self.placeholder = _placeholder!
        }
    }
    
   
    var floatingLabelColor: UIColor = UIColor.primary {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }

    
    var activeBorderColor: UIColor = UIColor.primary
    
    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
            self.setNeedsDisplay()
        }
    }
   
    var floatingLabelBackground: UIColor = UIColor.clear {
        didSet {
            self.floatingLabel.backgroundColor = self.floatingLabelBackground
            self.setNeedsDisplay()
        }
    }
    
   
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
   
    var _backgroundColor: UIColor = UIColor.clear {
        didSet {
            self.layer.backgroundColor = self._backgroundColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder // Make sure the placeholder is shown
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder // Make sure the placeholder is shown
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
    }
    
    // Add a floating label to the view on becoming first responder
    @objc func addFloatingLabel() {
        if self.text == "" {
            self.floatingLabel.textColor = floatingLabelColor
            self.floatingLabel.font = floatingLabelFont
            self.floatingLabel.text = self._placeholder
            self.floatingLabel.layer.backgroundColor = UIColor.clear.cgColor
            self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            self.floatingLabel.clipsToBounds = true
            self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width+4, height: floatingLabel.frame.height+2)
            self.floatingLabel.textAlignment = .center
            self.addSubview(self.floatingLabel)
            self.layer.borderColor = self.activeBorderColor.cgColor
            
            self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -10).isActive = true // Place our label 10 pts above the text field
            self.placeholder = ""
        }
        // Floating label may be stuck behind text input. we bring it forward as it was the last item added to the view heirachy
        self.bringSubviewToFront(subviews.last!)
        self.setNeedsDisplay()
    }
    
    @objc func removeFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
                self.subviews.forEach{ $0.removeFromSuperview() }
                self.setNeedsDisplay()
            }
            self.placeholder = self._placeholder
        }
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func addViewPasswordButton() {
        self.button.setImage(UIImage(named: "ic_reveal"), for: .normal)
        self.button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.button.frame = CGRect(x: 0, y: 16, width: 22, height: 16)
        self.button.clipsToBounds = true
        self.rightView = self.button
        self.rightViewMode = .always
        self.button.addTarget(self, action: #selector(self.enablePasswordVisibilityToggle), for: .touchUpInside)
    }
    
    func addImage(image: UIImage){
        
        self.imageView.image = image
        self.imageView.frame = CGRect(x: 20, y: 0, width: 20, height: 20)
        self.imageView.translatesAutoresizingMaskIntoConstraints = true
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.leftView = self.imageView
            self.leftViewMode = .always
        }
        
    }
    
    @objc func enablePasswordVisibilityToggle() {
        isSecureTextEntry.toggle()
        if isSecureTextEntry {
            self.button.setImage(UIImage(named: "ic_show"), for: .normal)
        }else{
            self.button.setImage(UIImage(named: "ic_hide"), for: .normal)
        }
    }
    
    func addBottomBorder() {
        let border = UIView(frame: CGRect(x: 0, y: self.frame.height-1, width: self.frame.width, height: 1))
        self.addSubview(border)
        border.backgroundColor = .primary
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addBottomBorder()
    }
}
