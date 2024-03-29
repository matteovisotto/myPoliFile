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
        let parameter: [String:Any] = ["field":"username", "values[0]":AppData.mySelf.username]
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
        let appName = UILabel()
        self.view.addSubview(appName)
        appName.translatesAutoresizingMaskIntoConstraints = false
        appName.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        appName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        appName.text = "myPoliFile"
        appName.font = .systemFont(ofSize: 40, weight: .black)
        appName.textColor = UIColor(named: "titlePrimary")
        
        let label = UILabel()
        label.text = NSLocalizedString("global.loading", comment: "Loading")
        label.textAlignment = .center
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: 5).isActive = true
        label.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
    }

}

extension LoadingViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
            if result {
                let errorHandler = ErrorParser(target: self, stringData: stringContent)
                if let errorType = errorHandler.getError() {
                    if errorType == .invalidToken {
                        DispatchQueue.main.async {
                            let forceLogout = ForceLogoutAlertController()
                            forceLogout.setAlert(title: NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString(errorType.rawValue, comment: "")) {
                                PreferenceManager.removeToken()
                                PreferenceManager.removePersonalCode()
                                PreferenceManager.removeFileDefaultAction()
                                PreferenceManager.removeCoursesReloading()
                                AppData.mySelf = User()
                                AppData.categories.removeAll()
                                 AppData.clearCourses()
                                
                                 var rVC: UIViewController? = nil
                                 if AppGlobal.deviceType == .iPhone {
                                     rVC = WelcomeViewController()
                                 } else {
                                     rVC = WelcomeIPadViewController()
                                 }
                                
                                let rootVC = UINavigationController(rootViewController: rVC!)
                                rootVC.navigationBar.isHidden = true
                                let ad = UIApplication.shared.delegate as! AppDelegate
                                let window = ad.window
                                window?.rootViewController = rootVC
                                window?.makeKeyAndVisible()
                            }
                            forceLogout.modalPresentationStyle = .overFullScreen
                            self.present(forceLogout, animated: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            let errorVC = ErrorAlertController()
                            errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString(errorType.rawValue, comment: ""))
                            errorVC.modalPresentationStyle = .overFullScreen
                            self.present(errorVC, animated: true, completion: nil)
                        }
                    }
                    return
                }
                
                if(taskManager == userTask) {
                    let uParser = UserParser(target: self, stringData: stringContent)
                    uParser.parse {
                        self.loadCategories()
                    }
                } else if (taskManager == categoryTask) {
                    let cParser = CategoryParser(target: self, stringData: stringContent)
                    cParser.parse {
                        var rootVC: UIViewController!
                        if(AppGlobal.deviceType == .iPad){
                            rootVC = MainViewController() //TODO:- Change this with iPad Main!
                        } else {
                            rootVC = MainViewController()
                        }
                        
                        let mainVC = UINavigationController(rootViewController: rootVC)
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
                    errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: stringContent)
                    errorVC.modalPresentationStyle = .overFullScreen
                    self.present(errorVC, animated: true, completion: nil)
                }
            }
        
    }
}
