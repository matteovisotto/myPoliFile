//
//  LessonParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 19/09/22.
//

import Foundation
import UIKit

class LessonParser {
    private var targetVC: UIViewController!
    private var stringData: String!
    
    init(target: UIViewController, stringData: String) {
        self.stringData = stringData
        self.targetVC = target
    }
    
    func parse(completionHandler: @escaping (_ discussion: Lesson)->()) {
        if let data = stringData.data(using: .utf8) {
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let p = result {
                    if let lessonData = p["lesson"] as? [String: Any] {
                        let name = StringParser.getTranslationFromTag(text: lessonData["name"] as! String)
                        let content = StringParser.getTranslationFromTag(text: lessonData["intro"] as! String)
                        let lesson = Lesson()
                        lesson.name = name
                        lesson.content = content
                        DispatchQueue.main.async {
                            completionHandler(lesson)
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
