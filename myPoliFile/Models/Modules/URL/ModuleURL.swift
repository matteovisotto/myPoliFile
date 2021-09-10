//
//  ModuleURL.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import Foundation
import UIKit

class ModuleURL: Module {
    
    var contents: [URLContent] = []
    
    required init() {
        super.init(modname: .url)
    }
    
    public static func parseContent(content: [[String: Any]]) -> [URLContent]{
        var contents: [URLContent] = []
        for c in content {
            contents.append(URLContent(content: c))
        }
        return contents
    }
}
