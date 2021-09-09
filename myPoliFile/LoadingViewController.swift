//
//  LoadingViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class LoadingViewController: BaseViewController {

    private var userInfoURL = ""
    private var categoriesURL = ""
    private var userTask: TaskManager!
    private var categoryTask: TaskManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        let parameter: [String:Any] = ["field":"username", "values[0]":User.mySelf.username]
        let p = LinkBuilder.prepareParameters(params: parameter)
        self.userInfoURL = LinkBuilder.build(serviceName: "core_user_get_users_by_field", withParameters: p)
        loadUserInfo()
        self.categoriesURL = LinkBuilder.build(serviceName: "core_course_get_categories")
    }
    
    private func loadUserInfo() {
        userTask = TaskManager(url: URL(string: userInfoURL)!)
        userTask.delegate = self
        userTask.execute()
    }
    
    private func loadCategories() {
        categoryTask = TaskManager(url: URL(string: self.categoriesURL)!)
        categoryTask.delegate = self
        categoryTask.execute()
    }
    
    private func setupLayout() {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon")
        
        let label = UILabel()
        label.text = "Loading..."
        label.textAlignment = .center
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        label.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
    }

}

extension LoadingViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
            //Load user information task result
            if result {
                if(taskManager == userTask) {
                    let uParser = UserParser(target: self, stringData: stringContent)
                    uParser.parse {
                        self.loadCategories()
                    }
                } else if (taskManager == categoryTask) {
                    let cParser = CategoryParser(target: self, stringData: stringContent)
                    cParser.parse {
                        let mainVC = UINavigationController(rootViewController: MainViewController())
                        mainVC.navigationBar.isHidden = true
                        let ad = UIApplication.shared.delegate as! AppDelegate
                        let window = ad.window
                        window?.rootViewController = mainVC
                        window?.makeKeyAndVisible()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                //Show error
                
                DispatchQueue.main.async {
                    let errorVC = ErrorAlertController()
                    errorVC.setContent(title: "Error", message: stringContent)
                    errorVC.modalPresentationStyle = .overFullScreen
                    self.present(errorVC, animated: true, completion: nil)
                }
            }
        
    }
}
