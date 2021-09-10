//
//  CourseContentViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import UIKit

class CourseContentViewController: BaseViewController {
    
    public var course: Course!
    private var courseTask: TaskManager!
    private var courseURL: String = ""
    private let navigationBar = BackHeader()
    private var loader = Loader()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadCourse()
    }
    
    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = backgroundColor
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        navigationBar.titleLabel.text = "Detail"
    }
    
    private func downloadCourse() {
        loader = CircleLoader.createGeometricLoader()
        loader.startAnimation()
        let parameters: [String: Any] = ["courseid":self.course.courseId]
        self.courseURL = LinkBuilder.build(serviceName: "core_course_get_contents", withParameters: LinkBuilder.prepareParameters(params: parameters))
        courseTask = TaskManager(url: URL(string: self.courseURL)!)
        courseTask.delegate = self
        courseTask.execute()
    }
    
    
    @objc private func didTapBack(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension CourseContentViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        if result {
            let detailParser = CourseDetailParser(target: self, stringData: stringContent, targetCourse: self.course)
            detailParser.parse {
                self.loader.stopAnimation()
                
            }
        } else {
            //Show error
            DispatchQueue.main.async {
                self.loader.stopAnimation()
                let errorVC = ErrorAlertController()
                errorVC.isLoadingPhase = false
                errorVC.setContent(title: "Error", message: stringContent)
                errorVC.modalPresentationStyle = .overFullScreen
                self.present(errorVC, animated: true, completion: nil)
            }
        }
    }
}

