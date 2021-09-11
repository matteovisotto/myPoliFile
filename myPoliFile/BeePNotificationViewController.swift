//
//  BeePNotificationViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import UIKit

class BeePNotificationViewController: BaseViewController {
    
    private var loader = Loader()
    private let navigationBar = BackHeader()
    private var newsTask: TaskManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadNews()
    }
    
    private func setNavigationBar() {
        self.view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = .groupTableViewBackground
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        navigationBar.titleLabel.text = ""
       
    }
    
    private func downloadNews() {
        Discussion.beepDiscussions.removeAll()
        loader = CircleLoader.createGeometricLoader()
        loader.startAnimation()
        let parameters: [String: Any] = ["forumid": 5]
        let url = LinkBuilder.build(serviceName: "mod_forum_get_forum_discussions", withParameters: LinkBuilder.prepareParameters(params: parameters))
        self.newsTask = TaskManager(url: URL(string: url)!)
        self.newsTask.delegate = self
        self.newsTask.execute()
    }
    
    @objc private func didTapBack() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
   
}

extension BeePNotificationViewController: TaskManagerDelegate {
    
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        DispatchQueue.main.async {
            self.loader.stopAnimation()
        }
        if result {
            let discParser = DiscussionParser(target: self, stringData: stringContent)
            discParser.globalBeepParse {
                for d in Discussion.beepDiscussions {
                    print(d.name + " (" + d.subject + ") " + d.content + " - by " + d.sender + " at " + d.date)
                }
            }
        } else {
            //Show error
            DispatchQueue.main.async {
                let errorVC = ErrorAlertController()
                errorVC.isLoadingPhase = false
                errorVC.setContent(title: "Error", message: stringContent)
                errorVC.modalPresentationStyle = .overFullScreen
                self.present(errorVC, animated: true, completion: nil)
            }
        }
    }
}
