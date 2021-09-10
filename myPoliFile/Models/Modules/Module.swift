//
//  Module.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import Foundation
import UIKit

class Module {
    enum Modname{
        case url
        case folder
        case label
        case forum
        case undefined
    }
    
    init(modname: Modname) {
        self.modname = modname
    }
    
    var name: String = ""
    public private(set) var modname: Modname = .undefined
    var instance: Int = 0
    
    public static func defineModname(modname: String) -> Modname {
        if (modname == "url") {
            return .url
        } else if (modname == "folder") {
            return .folder
        } else if (modname == "forum") {
            return .forum
        } else if (modname == "label") {
            return .label
        } else {
            return .undefined
        }
    }
    
}
