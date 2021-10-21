//
//  ModuleFolder.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import Foundation
import UIKit

class ModuleFolder: Module {
    
    var contents: [FolderContent] = []
    
    required init() {
        super.init(modname: .folder, icon: UIImage(named: "icon-folder")!)
    }
    
    public static func parseContent(content: [[String: Any]]) -> [FolderContent]{
        var contents: [FolderContent] = []
        for c in content {
            contents.append(FolderContent(content: c))
        }
        return contents
    }
}
