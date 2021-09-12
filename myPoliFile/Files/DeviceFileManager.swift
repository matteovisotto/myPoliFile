//
//  FileManager.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import Foundation
import UIKit

class DeviceFileManager {
    
    public static func loadFiles() -> [OfflineFile]?{
        var files: [OfflineFile] = []
        let fm = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)

        do {
            let items = try fm.contentsOfDirectory(atPath: path[0])
            for item in items {
                if(item != ".Trash"){
                    files.append(OfflineFile(fileURL: item))
                }
            }
            return files
        } catch {
            return nil
        }
    }
    
    public static func getFileUrl(forFile file: OfflineFile) -> URL? {
        do {
           let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            
            return documentsURL.appendingPathComponent(file.fileURL)
        } catch {
            return nil
        }
    }
    
}
