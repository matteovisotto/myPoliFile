//
//  ModuleContent.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 12/09/21.
//

import Foundation
import UIKit

class ModuleContent {
    var type: String = ""
    var contentName: String = ""
    var contentPath: String = ""
    var contentURL: String = ""
    var isOpenable: Bool = false
    
    
    func isFileOpenable(fileExtension: String) -> Bool {
        let allowedInWebView = ["pdf", "docx", "doc", "ppt", "pptx", "xls", "xlsx", "txt", "png", "gif", "jpg", "jpeg"]
        return allowedInWebView.contains(fileExtension)
    }
    
    func validateFileName(fileName str: String) -> String {
        let path = (str as NSString).pathExtension
        let fileName = (str as NSString).deletingPathExtension
        return fileName.replacingOccurrences(of: ".", with: "_") + "." + path
    }
}
