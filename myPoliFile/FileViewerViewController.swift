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
    
    open var file: ModuleContent!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        setupLayout()
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
    }
    
    
    @objc private func didTapback(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func didTapShare() {
        let downloader = Downloader(file: self.file)
        downloader.delegate = self
        downloader.startDownload()
    }
}

extension FileViewerViewController: DownloaderDelegate {
    func didDownloaded(result: Bool, url: URL?) {
        if(result){
            DispatchQueue.main.async {
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView=self.view
                activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                    try? FileManager.default.removeItem(at: url!)
                }
                self.present(activityViewController, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                let errorVC = ErrorAlertController()
                errorVC.setContent(title: "Error", message: "Unable to prepare the file")
                errorVC.modalPresentationStyle = .overFullScreen
                errorVC.isLoadingPhase = false
                errorVC.modalTransitionStyle = .coverVertical
                self.present(errorVC, animated: true, completion: nil)
            }
        }
    }
}
