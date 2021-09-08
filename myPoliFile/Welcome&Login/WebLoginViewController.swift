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
    private var navigationBar = UIView()
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
        self.view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.backgroundColor = backgroundColor
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = "PoliMi Login"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        navigationBar.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: navigationBar.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: navigationBar.rightAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: navigationBar.leftAnchor).isActive = true
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "arrowBack"), for: .normal)
        backButton.imageView?.tintColor = labelColor
        backButton.imageView?.contentMode = .scaleAspectFit
        navigationBar.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: 10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        backButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
        backButton.addTarget(self, action: #selector(didTapback), for: .touchUpInside)
        
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
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
        loadingView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
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
    
    @objc private func didTapback(){
        self.dismiss(animated: true, completion: nil)
    }

}
