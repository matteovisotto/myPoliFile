//
//  TaskManager.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import Foundation
import UIKit

protocol TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) -> Void
}

class TaskManager: NSObject {
    open var delegate: TaskManagerDelegate? = nil
    private var url: URL!
    
    required init(url: URL) {
        self.url = url
    }
    
    public func execute() {
        let request = URLRequest(url: self.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.delegate?.taskManager(taskManager: self, didFinishWith: false, stringContent: error.localizedDescription)
                return
            }
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            guard (200...299).contains(status) else {
                self.delegate?.taskManager(taskManager: self, didFinishWith: false, stringContent: "Error: \(status)")
                return
            }
            if let d = data {
                if let s = String(data: d, encoding: .utf8) {
                    self.delegate?.taskManager(taskManager: self, didFinishWith: true, stringContent: s)
                } else {
                    self.delegate?.taskManager(taskManager: self, didFinishWith: false, stringContent: NSLocalizedString("error.dataconversion", comment: "Data conversion error"))
                }
            } else {
                self.delegate?.taskManager(taskManager: self, didFinishWith: false, stringContent: NSLocalizedString("error.datareading", comment: "Data reading error"))
            }
        }
        task.resume()
    }
    
}

extension TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) -> Void {}
}
