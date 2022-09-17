//
//  PageContent.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 17/09/22.
//

import Foundation
import UIKit

class PageContent: ModuleContent {

    var fileExtension: String = ""
    
    init(content: [String: Any]) {
        super.init()
        self.type = content["type"] as! String
        self.contentName = validateFileName(fileName: content["filename"] as! String)
        if(self.type == "file" && (content["fileurl"] as! String).contains("forcedownload")){
            self.contentURL = (content["fileurl"] as! String) + "&token=" + AppData.mySelf.token
        } else if (self.type == "file" && !(content["fileurl"] as! String).contains("?")) {
            self.contentURL = (content["fileurl"] as! String) + "?token=" + AppData.mySelf.token
        } else {
            self.contentURL = content["fileurl"] as! String
        }
        self.contentPath = content["filepath"] as! String
        self.fileExtension = (self.contentName as NSString).pathExtension
        self.isOpenable = isFileOpenable(fileExtension: self.fileExtension)
    }
    
    
    
}

