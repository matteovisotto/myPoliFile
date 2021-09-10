//
//  FolderContent.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import Foundation
import UIKit

class FolderContent {
    var type: String = ""
    var contentName: String = ""
    var contentPath: String = ""
    var contentURL: String = ""
    var mimetype: String = ""
    var author: String = ""
    
    init(content: [String: Any]) {
        self.type = content["type"] as! String
        self.contentName = content["filename"] as! String
        self.contentURL = content["fileurl"] as! String
        self.contentPath = content["filepath"] as! String
        self.mimetype = content["mimetype"] as! String
        self.author = content["author"] as! String
    }
}
