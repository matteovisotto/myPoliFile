//
//  BaseViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    open var backgroundColor: UIColor  {
        var c: UIColor = UIColor.white
        if #available(iOS 13.0, *) {
            c = UIColor.systemBackground
        }
        return c
    }
    
    open var labelColor: UIColor {
        var c: UIColor = UIColor.black
        if #available(iOS 13.0, *) {
            c = UIColor.label
        }
        return c
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
    }
}
