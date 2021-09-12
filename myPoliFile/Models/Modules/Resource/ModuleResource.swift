//
//  ModuleResource.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 12/09/21.
//

import Foundation
import UIKit

class ModuleResource: Module {
    var contents: ResourceContent?
    
    required init() {
        super.init(modname: .resource, icon: UIImage(named: "icon-resource")!)
    }
    
    public static func parseContent(content: [[String: Any]]) -> ResourceContent?{
        if content.count == 1 {
            return ResourceContent(content: content[0])
        }
        return nil
    }
}
