//
//  FileViewerViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import UIKit
import WebKit

class FileViewerViewController: BaseViewController {

    private var webView = WKWebView()
    private var navigationBar = BackHeader()
    private var shareButton = UIButton()
    private let loaderView = HorizontalProgressBar()
    
    open var file: ModuleContent!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        setupLayout()
        createLoaderView()
        let url = URL(string: file.contentURL)!
        let request = URLRequest(url: url)
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
        navigationBar.backButton.addTarget(self, action: #selector(didTapback), for: .touchUpInside)
        navigationBar.titleLabel.text = file.contentName
        shareButton.setImage(UIImage(named: "iconShare"), for: .normal)
        shareButton.imageView?.tintColor = labelColor
        shareButton.imageView?.contentMode = .scaleAspectFit
        
        navigationBar.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -10).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 25).isActive = true //25
        shareButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        shareButton.centerYAnchor.constraint(equalTo: navigationBar.centerYAnchor).isActive = true
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
    }
    
    private func createLoaderView() {
        self.view.addSubview(loaderView)
        loaderView.progress = 0
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        loaderView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 5).isActive = true
        loaderView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -5).isActive = true
        loaderView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        loaderView.color = .buttonPrimary
    }
    
    private func removeLoaderView() {
        loaderView.removeFromSuperview()
    }
    
    @objc private func didTapback(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func didTapShare() {
        let downloader = Downloader(file: self.file, fileDirectory: .itemReplacementDirectory)
        downloader.delegate = self
        downloader.startDownload()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let progressValue = Float(webView.estimatedProgress)
            loaderView.progress = CGFloat(progressValue)
        }
    }
}

extension FileViewerViewController: DownloaderDelegate {
    func didDownloaded(result: Bool, url: URL?) {
        if(result){
            DispatchQueue.main.async {
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
                activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                    try? FileManager.default.removeItem(at: url!)
                }
                self.present(activityViewController, animated: true, completion: nil)
                if let popOver = activityViewController.popoverPresentationController {
                    popOver.sourceView = self.view
                    popOver.sourceRect = self.shareButton.frame
                }
            }
        } else {
            DispatchQueue.main.async {
                let errorVC = ErrorAlertController()
                errorVC.setContent(title:NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString("error.filepreparation", comment: "Error file preparation"))
                errorVC.modalPresentationStyle = .overFullScreen
                errorVC.isLoadingPhase = false
                errorVC.modalTransitionStyle = .coverVertical
                self.present(errorVC, animated: true, completion: nil)
            }
        }
    }
}

extension FileViewerViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        removeLoaderView()
    }
}
