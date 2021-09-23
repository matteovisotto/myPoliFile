//
//  NotificationParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 13/09/21.
//

import Foundation
import UIKit

class NotificationParser {
    private var targetVC: UIViewController!
    private var stringData: String!
    
    init(target: UIViewController, stringData: String) {
        self.stringData = stringData
        self.targetVC = target
    }
    
    func parse(completionHandler: @escaping ()->()) {
        if let data = stringData.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let p = result {
                    let d = p["notifications"] as? [[String:Any]]
                    if let notifications = d {
                        for not in notifications {
                            let id = not["id"] as! Int
                            let title = not["contexturlname"] as! String
                            let contentHTML = not["fullmessagehtml"] as! String
                            let timeCreated = timestampToString(timestamp: not["timecreated"] as! Double)
                            let newN = Notification()
                            newN.id = id
                            newN.title = title
                            newN.htmlContent = contentHTML
                            newN.timeCreated = timeCreated
                            Notification.notifications.append(newN)
                        }
                        DispatchQueue.main.async {
                            completionHandler()
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
