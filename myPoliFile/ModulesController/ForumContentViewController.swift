//
//  ForumContentViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 16/09/21.
//

import Foundation
import UIKit
import WebKit

class ForumContentViewController: BaseViewController {
    private var webView = WKWebView()
    private var navigationBar = BackHeader()
    
    open var discussion: Discussion!
    private var contentString: String = ""
    private var replies: [Discussion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        setupLayout()
        navigationBar.titleLabel.text = discussion.subject
        loadData()
    }
    
    private func setupLayout() {
        self.view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = backgroundColor
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.backButton.addTarget(self, action: #selector(didTapback), for: .touchUpInside)
        
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    @objc private func didTapback(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadData() {
        let par: [String: Any] = ["discussionid": self.discussion.discussionId]
        let urlStr = LinkBuilder.build(serviceName: "mod_forum_get_discussion_posts", withParameters: LinkBuilder.prepareParameters(params: par))
        let task = TaskManager(url: URL(string: urlStr)!)
        task.delegate = self
        task.execute()
    }
}

extension ForumContentViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        if result {
            let parser = ForumPostsParser(target: self, stringData: stringContent)
            parser.parse(completionHandler: { discussions in
                self.replies = discussions.dropLast()
                self.contentString = WebpageBuilder.preparePage(forForumDiscussion: self.discussion, withReplies: self.replies)
                self.webView.loadHTMLString(self.contentString, baseURL: nil)
            })
        } else {
            DispatchQueue.main.async {
                self.webView.loadHTMLString("<h1>Error</h1>", baseURL: nil)
            }
        }
    }
}
