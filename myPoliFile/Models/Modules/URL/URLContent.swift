//
//  URLContent.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import Foundation
import UIKit

class URLContent {
    
    var type: String = ""
    var contentName: String = ""
    var contentURL: String = ""
    
    
    init(content: [String: Any]) {
        self.type = content["type"] as! String
        self.contentName = content["filename"] as! String
        self.contentURL = content["fileurl"] as! String
    }
    
}
