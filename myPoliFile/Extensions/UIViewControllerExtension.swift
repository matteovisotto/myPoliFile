//
//  UIViewControllerExtension.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

 extension UIViewController {
     func hideKeyboardWhenTappedAround() {
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
         tap.cancelsTouchesInView = false
         view.addGestureRecognizer(tap)
     }
     
     @objc func dismissKeyboard() {
         view.endEditing(true)
     }
 }
