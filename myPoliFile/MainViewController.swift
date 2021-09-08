//
//  MainViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class MainViewController: BaseViewController {

    private var courseTask: TaskManager!
    private var courses: [Course] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCourses()
    }
    
    private func downloadCourses() {
        let parameters: [String: Any] = ["userid":User.mySelf.userId]
        let urlString = LinkBuilder.build(serviceName: "core_enrol_get_users_courses", withParameters: LinkBuilder.prepareParameters(params: parameters))
        self.courseTask = TaskManager(url: URL(string: urlString)!)
        self.courseTask.delegate = self
        self.courseTask.execute()
    }

}

extension MainViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        if result {
            if let data = stringContent.data(using: .utf8) {
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
                                self.courses.append(newCourse)
                                DispatchQueue.main.async {
                                    //Update View
                                    
                                }
                            } else {
                                let errorVC = ErrorAlertController()
                                errorVC.setContent(title: "Error", message: "Unable to parse your personal data")
                                errorVC.modalPresentationStyle = .overFullScreen
                                DispatchQueue.main.async {
                                    self.present(errorVC, animated: true, completion: nil)
                                }
                            }
                        }
                           
                    } else {
                        let errorVC = ErrorAlertController()
                        errorVC.setContent(title: "Error", message: "Unable to convert the received data")
                        errorVC.modalPresentationStyle = .overFullScreen
                        DispatchQueue.main.async {
                            self.present(errorVC, animated: true, completion: nil)
                        }                    }
                } catch {
                    let errorVC = ErrorAlertController()
                    errorVC.setContent(title: "Error", message: error.localizedDescription)
                    errorVC.modalPresentationStyle = .overFullScreen
                    DispatchQueue.main.async {
                        self.present(errorVC, animated: true, completion: nil)
                    }
                }
            }
        } else {
            //Show error
            let errorVC = ErrorAlertController()
            errorVC.setContent(title: "Error", message: stringContent)
            errorVC.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                self.present(errorVC, animated: true, completion: nil)
            }
        }
        
    }
}

