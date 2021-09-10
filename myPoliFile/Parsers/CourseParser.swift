//
//  CourseParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

class CourseParser {
    
    private var targetVC: UIViewController!
    private var stringData: String!
    
    init(target: UIViewController, stringData: String) {
        self.stringData = stringData
        self.targetVC = target
    }
    
    func parse(completionHandler: @escaping ()->()) {
        if let data = stringData.data(using: .utf8) {
            do {
                let courses = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
                if let c = courses {
                    for course in c {
                        if let cu = course as? [String: Any] {
                            let courseId: Int = cu["id"] as! Int
                            let fullname: String = cu["fullname"] as! String
                            let displayName: String = cu["displayname"] as! String
                            let category: Int = cu["category"] as! Int
                            let isHidden: Bool = cu["hidden"] as! Bool
                            let isFavourite: Bool = cu["isfavourite"] as! Bool
                            
                            let newCourse = Course()
                            newCourse.courseId = courseId
                            newCourse.fullname = fullname
                            newCourse.displayName = displayName
                            newCourse.category = category
                            newCourse.isHidden = isHidden
                            newCourse.isFavourite = isFavourite
                            if(isHidden){
                                Course.hidden.append(newCourse)
                            } else {
                                Course.courses.append(newCourse)
                                if(isFavourite){
                                    Course.favourite.append(newCourse)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                let errorVC = ErrorAlertController()
                                errorVC.setContent(title: "Error", message: "Unable to parse your personal data")
                                errorVC.modalPresentationStyle = .overFullScreen
                                self.targetVC.present(errorVC, animated: true, completion: nil)
                            }
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        completionHandler()
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
}
