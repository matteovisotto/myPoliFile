//
//  OfflineFolder.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 13/09/21.
//

import Foundation
import UIKit

class OfflineFolder {
    var folderURL: String!
    var folderName: String!
    
    init(folderURL: String, parent: String) {
        self.folderName = folderURL.replacingOccurrences(of: "_", with: " ")
        if(parent=="/"){
            self.folderURL = folderURL
        } else {
            self.folderURL = parent+"/"+folderURL
        }
    }
    
}
