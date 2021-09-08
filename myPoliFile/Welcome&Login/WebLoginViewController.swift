//
//  WebLoginViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit
import WebKit

class WebLoginViewController: BaseViewController, WKNavigationDelegate {
    
    private var webView = WKWebView()
    private var loadingView: UIView!
    var callback: (_ content: String)->() = {_ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        let url = URL(string: WebManager.loginUrl)!
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
    }
    
    private func setupLayout() {
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func prepareLoadingView() {
        loadingView = UIView()
        loadingView.backgroundColor = backgroundColor
        let label = UILabel()
        label.text = "Completing login..."
        label.font = .boldSystemFont(ofSize: 30)
        label.numberOfLines = .zero
        label.textAlignment = .center
        loadingView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: loadingView.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: loadingView.rightAnchor, constant: -10).isActive = true
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        loadingView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let currentUrl:String = webView.url!.absoluteString
        if (currentUrl.starts(with: "https://shibidp.polimi.it")) {
            prepareLoadingView()
        } else if(currentUrl == WebManager.homeUrl) {
            webView.load(URLRequest(url: URL(string: "https://webeep.polimi.it/login/token.php?username=" + User.mySelf.username + "&password=&service=moodle_mobile_app")!))
        } else if (currentUrl == "https://webeep.polimi.it/login/token.php?username=" + User.mySelf.username + "&password=&service=moodle_mobile_app") {
            webView.evaluateJavaScript("document.documentElement.innerText.toString()",
                                       completionHandler: { (html: Any?, error: Error?) in
                                        self.dismiss(animated: true, completion: nil)
                                        DispatchQueue.main.async {
                                            self.callback(html as! String)
                                        }
                                        
            })
        }
    }

}
