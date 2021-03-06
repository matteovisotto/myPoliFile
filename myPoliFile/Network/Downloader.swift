//
//  Downloader.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import Foundation
import UIKit

import Foundation
import UIKit

protocol DownloaderDelegate {
    func didDownloaded(result: Bool, url: URL?)
}


class Downloader {
    private let urlSession = URLSession.shared
    private var file: ModuleContent!
    private var directoryPath: FileManager.SearchPathDirectory = .documentDirectory
    var delegate: DownloaderDelegate? = nil
    
    init(file: ModuleContent, fileDirectory: FileManager.SearchPathDirectory = .documentDirectory) {
        self.file = file
        self.directoryPath = fileDirectory
    }
    
    func startDownload () -> Void {
        let fileURL = URL(string: file.contentURL)!
        let fileName = file.contentName
        let downloadTask = urlSession.downloadTask(with: fileURL) { url, response, error in
            guard let downloadedURL = url else { return }
            let filePath = self.file.contentPath.replacingOccurrences(of: " ", with: "_")
            do {
                var documentsURL: URL? = nil
                if(self.directoryPath == .documentDirectory){
                    documentsURL = try
                        FileManager.default.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)
                } else {
                    documentsURL = FileManager.default.temporaryDirectory
                }
                let folderURL = documentsURL!.appendingPathComponent(AppData.currentCourseFolder+"/"+AppData.currentModuleFolder+filePath)
                if !FileManager.default.fileExists(atPath: folderURL.absoluteString) {
                    try! FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                }
                
                let savedURL = folderURL.appendingPathComponent(fileName)
                try? FileManager.default.removeItem(at: savedURL)
                try FileManager.default.moveItem(at: downloadedURL, to: savedURL)
                self.delegate?.didDownloaded(result: true, url: savedURL)
            } catch {
                self.delegate?.didDownloaded(result: false, url: nil)
            }
        }
        downloadTask.resume()
    }
}

