//
//  ModuleForum.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import Foundation
import UIKit

class ModuleForum: Module {
    
    open var content: [Discussion] = []
    
    required init() {
        super.init(modname: .forum, icon: UIImage(named: "icon-forum")!)
    }
}
