//
//  LoadingViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class LoadingViewController: BaseViewController {

    private var userInfoURL = ""
    private var userTask: TaskManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        let parameter: [String:Any] = ["field":"username", "values[0]":User.mySelf.username]
        let p = LinkBuilder.prepareParameters(params: parameter)
        self.userInfoURL = LinkBuilder.build(serviceName: "core_user_get_users_by_field", withParameters: p)
        loadUserInfo()
    }
    
    private func loadUserInfo() {
        userTask = TaskManager(url: URL(string: userInfoURL)!)
        userTask.delegate = self
        userTask.execute()
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
                if let data = stringContent.data(using: .utf8) {
                    do {
                        let people = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
                        if let p = people {
                            if (p.count == 1) {
                                let person = p[0] as? [String:Any]
                                if let pr = person {
                                    let userId: Int = pr["id"] as! Int
                                    let fullname: String = pr["fullname"] as! String
                                    let email: String = pr["email"] as! String
                                    User.mySelf.email = email
                                    User.mySelf.fullname = fullname
                                    User.mySelf.userId = userId
                                    DispatchQueue.main.async {
                                        //Go to main app
                                        let mainVC = TestViewController()
                                        let ad = UIApplication.shared.delegate as! AppDelegate
                                        let window = ad.window
                                        window?.rootViewController = mainVC
                                        window?.makeKeyAndVisible()
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                } else {
                                    let errorVC = ErrorAlertController()
                                    errorVC.setContent(title: "Error", message: "Unable to parse your personal data")
                                    errorVC.modalPresentationStyle = .overFullScreen
                                    self.present(errorVC, animated: true, completion: nil)
                                }
                            } else {
                                let errorVC = ErrorAlertController()
                                errorVC.setContent(title: "Error", message: "Unable to find your personal data")
                                errorVC.modalPresentationStyle = .overFullScreen
                                self.present(errorVC, animated: true, completion: nil)
                            }
                        } else {
                            let errorVC = ErrorAlertController()
                            errorVC.setContent(title: "Error", message: "Unable to convert the received data")
                            errorVC.modalPresentationStyle = .overFullScreen
                            self.present(errorVC, animated: true, completion: nil)
                        }
                    } catch {
                        let errorVC = ErrorAlertController()
                        errorVC.setContent(title: "Error", message: error.localizedDescription)
                        errorVC.modalPresentationStyle = .overFullScreen
                        self.present(errorVC, animated: true, completion: nil)
                    }
                }
            } else {
                //Show error
                let errorVC = ErrorAlertController()
                errorVC.setContent(title: "Error", message: stringContent)
                errorVC.modalPresentationStyle = .overFullScreen
                self.present(errorVC, animated: true, completion: nil)
            }
        
    }
}
