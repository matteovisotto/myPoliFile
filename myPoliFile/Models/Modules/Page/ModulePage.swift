//
//  ModulePage.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 16/09/22.
//

import Foundation
import UIKit

class ModulePage: Module {
    
    var contents: [PageContent] = [] {
        didSet {
            for c in contents {
                if (c.fileExtension == "html") {
                    indexPage = c.contentURL
                }
            }
        }
    }
    
    var indexPage = ""
    
    required init() {
        super.init(modname: .page, icon: UIImage(named: "icon-page")!)
    }
    
    public static func parseContent(content: [[String: Any]]) -> [PageContent]{
        var contents: [PageContent] = []
        for c in content {
            contents.append(PageContent(content: c))
        }
        return contents
    }
}

