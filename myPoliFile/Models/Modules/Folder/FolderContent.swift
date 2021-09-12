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
    var isOpenable: Bool = false
    var fileExtension: String = ""
    
    init(content: [String: Any]) {
        self.type = content["type"] as! String
        self.contentName = content["filename"] as! String
        if(self.type == "file" && (content["fileurl"] as! String).contains("forcedownload")){
            self.contentURL = (content["fileurl"] as! String) + "&token=" + User.mySelf.token
        } else if (self.type == "file" && !(content["fileurl"] as! String).contains("?")) {
            self.contentURL = (content["fileurl"] as! String) + "?token=" + User.mySelf.token
        } else {
            self.contentURL = content["fileurl"] as! String
        }
        self.contentPath = content["filepath"] as! String
        self.mimetype = content["mimetype"] as! String
        self.author = content["author"] as! String
        self.fileExtension = (self.contentName as NSString).pathExtension
        self.isOpenable = isFileOpenable(fileExtension: self.fileExtension)
    }
    
    private func isFileOpenable(fileExtension: String) -> Bool {
        let allowedInWebView = ["pdf", "docx", "doc", "ppt", "pptx", "xls", "xlsx", "txt", "png", "gif", "jpg", "jpeg"]
        return allowedInWebView.contains(fileExtension)
    }
    
}
