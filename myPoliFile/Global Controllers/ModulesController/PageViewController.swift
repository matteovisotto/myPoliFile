//
//  PageViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 17/09/22.
//

import Foundation
import UIKit

class PageViewController: BaseViewController {
    private var navigationBar = BackHeader()
    private var loader = Loader()
    
    private var contentView: UITextView = UITextView()
    
    var page: ModulePage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        setupLayout()
        self.navigationBar.titleLabel.text = page.name
        downloadPage()
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
        
        self.view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        contentView.isEditable = false
        contentView.delegate = self
    }
    
    private func downloadPage() {
        self.loader = CircleLoader.createGeometricLoader()
        self.loader.startAnimation()
        let pageTask = TaskManager(url: URL(string: self.page.indexPage)!)
        pageTask.delegate = self
        pageTask.execute()
    }
    
    @objc private func didTapback(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension PageViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let stringUrl = URL.absoluteString
        if (stringUrl.starts(with: "http://") || stringUrl.starts(with: "https://")) {
            UIApplication.shared.open(URL)
        } else {
            guard let last = stringUrl.components(separatedBy: "/").last else {return false}
            for c in self.page.contents {
                if (c.contentURL.contains(last) && c.isOpenable){
                    let fileAction = FileOpenAction(target: self, moduleContent: c, loader: self.loader)
                    fileAction.displayActions()
                }
            }
        }
        return false
    }
}

extension PageViewController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        DispatchQueue.main.async {
            self.loader.stopAnimation()
        }
        if result{
            DispatchQueue.main.async {
                self.contentView.attributedText = stringContent.html2Attributed
            }
        } else {
            //Show error
            DispatchQueue.main.async {
                self.loader.stopAnimation()
                let errorVC = ErrorAlertController()
                errorVC.isLoadingPhase = false
                errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: stringContent)
                errorVC.modalPresentationStyle = .overFullScreen
                self.present(errorVC, animated: true, completion: nil)
            }
        }
    }
}
