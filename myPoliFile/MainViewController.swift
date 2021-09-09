//
//  MainViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class MainViewController: BaseViewController {

    private var courseTask: TaskManager!
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
            let parser = CourseParser(target: self, stringData: stringContent)
            parser.parse {
                //Update View -> Already in the mail thread
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

