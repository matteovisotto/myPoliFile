//
//  OfflineFile.swift
//  BeeP-PoliMi
//
//  Created by Matteo Visotto on 05/03/2020.
//  Copyright © 2020 Matteo Visotto. All rights reserved.
//

import Foundation

class OfflineFile {
    var fileURL: String!
    var fileName: String!
    var fileExtension: String!
    
    init(fileURL: String){
        
        let fileParts = (fileURL as NSString).components(separatedBy: ".")
        self.fileURL = fileURL
        self.fileName = fileParts[0]
        self.fileExtension = fileParts[safe: 1]
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
