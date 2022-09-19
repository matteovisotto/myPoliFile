//
//  LessonViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 19/09/22.
//

import Foundation
import UIKit

class LessonViewController: BaseViewController {
    private var navigationBar = BackHeader()
    private var loader = Loader()
    
    private var contentView: UITextView = UITextView()
    
    private var model: LessonViewModel!
    
    var lesson: ModuleLesson!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        setupLayout()
        self.navigationBar.titleLabel.text = lesson.name
        self.model = LessonViewModel(target: self, contentView: self.contentView, lesson: self.lesson, loader: self.loader)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.model.loadData()
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
    
    
    @objc private func didTapback(){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension LessonViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL,
                  in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        model.handleURLAction(URL)
        return false
    }
}
