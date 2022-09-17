//
//  ModulePage.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 16/09/22.
//

import Foundation
import UIKit

class ModulePage: Module {
    
    var contents: [PageContent] = []
    
    required init() {
        super.init(modname: .page, icon: UIImage(named: "icon-page")!)
    }
    
    public static func parseContent(content: [[String: Any]]) -> [PageContent]{
        var contents: [PageContent] = []
        for c in content {
            //contents.append(FolderContent(content: c))
        }
        return contents
    }
}

