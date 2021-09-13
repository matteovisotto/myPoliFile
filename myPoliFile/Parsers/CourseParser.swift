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
                                errorVC.setContent(title: "Error", message: "Unable to parse course data")
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
    
    public static func parseCourseName(_ text: String) -> CourseName{
        let cName = CourseName()
        if (text.contains("{mlang}")){
            var regex = "\\{mlang\\}\\{mlang [a-z]{2}\\}"
            var repl = "\n"
            let txt = text.replacingOccurrences(of: regex, with: repl, options: [.regularExpression])
            regex = "\\{mlang[ ]?[a-z]*\\}"
            repl = ""
            cName.courseName = txt.replacingOccurrences(of: regex, with: repl, options: [.regularExpression])
            return cName
        } else if (text.range(of: "^[0-9]{4}", options: .regularExpression) != nil && text.contains("-")){
            var divided = text.split(separator: "-")
            cName.courseNumber = divided[0].replacingOccurrences(of: " ", with: "")
            divided.remove(at: 0)
            var fullCourseName = ""
            for s in divided {
                fullCourseName = fullCourseName + s
            }
            let secondDivision = fullCourseName.split(separator: "(")
            if secondDivision.count >= 2 {
                let courseName = secondDivision[0]
                let courseProf = secondDivision[1].replacingOccurrences(of: ")", with: "")
                cName.courseName = String(courseName).trimmingCharacters(in: .whitespacesAndNewlines)
                cName.courseProf = courseProf.trimmingCharacters(in: .whitespacesAndNewlines)
                return cName
            }
            cName.courseName = String(fullCourseName).trimmingCharacters(in: .whitespacesAndNewlines)
            return cName
        }
        cName.courseName = text
        return cName
    }
    
}
