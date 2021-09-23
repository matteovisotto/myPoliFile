//
//  DiscussionParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import Foundation
import UIKit

class ForumParser {
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
                    let d = p["discussions"] as? [[String:Any]]
                    if let discussions = d {
                        for discussion in discussions {
                            let name = fixLangTag(string: discussion["name"] as! String)
                            let subject = fixLangTag(string: discussion["subject"] as! String)
                            let content = fixLangTag(string: discussion["message"] as! String)
                            let sender = discussion["userfullname"] as! String
                            let discussionId = discussion["discussion"] as! Int
                            let date = timestampToString(timestamp: discussion["modified"] as! Double)
                            let disc = Discussion()
                            disc.name = name
                            disc.subject = subject
                            disc.content = content
                            disc.sender = sender
                            disc.date = date
                            disc.discussionId = discussionId
                            parsedDiscussion.append(disc)
                        }
                        DispatchQueue.main.async {
                            completionHandler(parsedDiscussion)
                        }
                    } else {
                        DispatchQueue.main.async {
                            let errorVC = ErrorAlertController()
                            errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString("error.datareading", comment: "Data reading error"))
                            errorVC.modalPresentationStyle = .overFullScreen
                            self.targetVC.present(errorVC, animated: true, completion: nil)
                        }
                        return
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        let errorVC = ErrorAlertController()
                        errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString("error.dataconversion", comment: "Data conversion error"))
                        errorVC.modalPresentationStyle = .overFullScreen
                        self.targetVC.present(errorVC, animated: true, completion: nil)
                    }
                    return
                }
            } catch {
                
                DispatchQueue.main.async {
                    let errorVC = ErrorAlertController()
                    errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: error.localizedDescription)
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
