//
//  ForumPostsParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 16/09/21.
//

import Foundation
import UIKit

class ForumPostsParser {
    private var targetVC: UIViewController!
    private var stringData: String!
    
    init(target: UIViewController, stringData: String) {
        self.stringData = stringData
        self.targetVC = target
    }
    
    func parse(completionHandler: @escaping (_ discussion: [Discussion])->()) {
        var parsedDiscussion: [Discussion] = []
        if let data = stringData.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let p = result {
                    let d = p["posts"] as? [[String:Any]]
                    if let discussions = d {
                        for discussion in discussions {
                            let subject = fixLangTag(string: discussion["subject"] as! String)
                            let content = fixLangTag(string: discussion["message"] as! String)
                            let date = timestampToString(timestamp: discussion["timemodified"] as! Double)
                            let author = (discussion["author"] as! [String: Any])["fullname"] as! String
                            let disc = Discussion()
                            disc.subject = subject
                            disc.sender = author
                            disc.content = content
                            disc.date = date
                            parsedDiscussion.append(disc)
                        }
                        DispatchQueue.main.async {
                            completionHandler(parsedDiscussion)
                        }
                    } else {
                        DispatchQueue.main.async {
                            let errorVC = ErrorAlertController()
                            errorVC.setContent(title: "Error", message: "Unable to find content")
                            errorVC.modalPresentationStyle = .overFullScreen
                            self.targetVC.present(errorVC, animated: true, completion: nil)
                        }
                        return
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        let errorVC = ErrorAlertController()
                        errorVC.setContent(title: "Error", message: "Unable to convert the received data")
                        errorVC.modalPresentationStyle = .overFullScreen
                        self.targetVC.present(errorVC, animated: true, completion: nil)
                    }
                    return
                }
            } catch {
                
                DispatchQueue.main.async {
                    let errorVC = ErrorAlertController()
                    errorVC.setContent(title: "Error", message: error.localizedDescription)
                    errorVC.modalPresentationStyle = .overFullScreen
                    self.targetVC.present(errorVC, animated: true, completion: nil)
                }
                return
            }
        }
    }
    
    private func fixLangTag(string: String) -> String {
        if (string.contains("{mlang}")){
            var regex = "\\{mlang [a-z]{2}\\}(.*)\\{mlang\\}\\{mlang [a-z]{2}\\}"
            var repl = ""
            let txt = string.replacingOccurrences(of: regex, with: repl, options: [.regularExpression])
            regex = "\\{mlang\\}"
            repl = ""
            return txt.replacingOccurrences(of: regex, with: repl, options: [.regularExpression])
        }
        return string
    }
    
    
    private func timestampToString(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.locale = Calendar.current.locale
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
}
