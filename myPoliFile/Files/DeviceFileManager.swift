//
//  FileManager.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import Foundation
import UIKit

class DeviceFileManager {
    
    public static func loadFiles(forDirectoryPath dirPath: String = "/") -> [String: [Any]]?{
        var files: [OfflineFile] = []
        var folders: [OfflineFolder] = []
        let fm = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let folderPath = URL(string: path[0])!.appendingPathComponent(dirPath)
        do {
            let items = try fm.contentsOfDirectory(atPath: folderPath.absoluteString)
            for item in items {
                let itemURL = URL(string: "file://" + folderPath.absoluteString)!.appendingPathComponent(item)
                guard let isDir = (try itemURL.resourceValues(forKeys: [.isDirectoryKey])).isDirectory else {continue}
                
                if(item != ".Trash" && !isDir){
                    files.append(OfflineFile(fileURL: item))
                } else if (item != ".Trash" && isDir) {
                    folders.append(OfflineFolder(folderURL: item, parent: dirPath))
                }
            }
            return ["folders": folders, "files": files]
        } catch {
            return nil
        }
    }
    
    public static func getFileUrl(forFile file: OfflineFile, inCourseFolder folder: String = "/") -> URL? {
        do {
           let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            
            return documentsURL.appendingPathComponent(folder).appendingPathComponent(file.fileURL)
        } catch {
            return nil
        }
    }
    
    public static func deleteFile(using file: OfflineFile, inCourseFolder folder: String) -> Bool {
        do {
           let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            
            let folderURL = documentsURL.appendingPathComponent(folder)
            let fileURL = folderURL.appendingPathComponent(file.fileURL)
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            return false
        }
    }
    
    public static func deleteFolder(using folder: OfflineFolder) -> Bool {
        do {
           let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
            
            let folderURL = documentsURL.appendingPathComponent(folder.folderURL)
            try FileManager.default.removeItem(at: folderURL)
            return true
        } catch {
            return false
        }
    }
}
