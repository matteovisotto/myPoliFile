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
    var delegate: DownloaderDelegate? = nil
    init(file: ModuleContent) {
        self.file = file
    }
    
    func startDownload () -> Void {
        let fileURL = URL(string: file.contentURL)!
        let fileName = file.contentName
        let downloadTask = urlSession.downloadTask(with: fileURL) { url, response, error in
            guard let downloadedURL = url else { return }
            do {
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                let savedURL = documentsURL.appendingPathComponent(fileName)
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

