//
//  AppQLPreviewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 21/10/21.
//

import Foundation
import UIKit
import QuickLook

class AppQLPreviewController: QLPreviewController {
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}
