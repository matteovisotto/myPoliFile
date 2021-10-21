//
//  SearchCourseParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import Foundation
import UIKit

class SearchCourseParser {
    private var targetVC: UIViewController!
    private var stringData: String!
    
    init(target: UIViewController, stringData: String) {
        self.stringData = stringData
        self.targetVC = target
    }
    
    func parse(completionHandler: @escaping (_ courses: [Course])->()) {
        var results: [Course] = []
        if let data = stringData.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let c = result {
                    let cAr = c["courses"] as? [[String: Any]]
                    if let courses = cAr {
                        for course in courses {
                            let newC = Course()
                            newC.category = course["categoryid"] as! Int
                            newC.displayName = course["displayname"] as! String
                            newC.fullname = course["fullname"] as! String
                            newC.courseId = course["id"] as! Int
                            results.append(newC)
                        }
                        DispatchQueue.main.async {
                            completionHandler(results)
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
}
