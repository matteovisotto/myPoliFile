//
//  LessonViewModel.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 19/09/22.
//

import Foundation
import UIKit

class LessonViewModel {
    private var target: UIViewController!
    private var contentView: UITextView!
    private var loader: Loader?
    private var lesson: ModuleLesson!
    
    required init (target: UIViewController, contentView: UITextView, lesson: ModuleLesson, loader: Loader?) {
        self.target = target
        self.contentView = contentView
        self.lesson = lesson
        self.loader = loader
    }
    
    func loadData() {
        self.loader = CircleLoader.createGeometricLoader()
        self.loader?.startAnimation()
        let parameters: [String: Any] = ["lessonid": lesson.instance]
        let urlStr = LinkBuilder.build(serviceName: "mod_lesson_get_lesson", withParameters: LinkBuilder.prepareParameters(params: parameters))
        let lessonTask = TaskManager(url: URL(string: urlStr)!)
        lessonTask.delegate = self
        lessonTask.execute()
    }
    
    func handleURLAction(_ url: URL) -> Void {
        let urlString = url.absoluteString
        if(urlString.starts(with: "https://") || urlString.starts(with: "http://")){
            UIApplication.shared.open(url)
        }
    }
    
}

extension LessonViewModel: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        DispatchQueue.main.async {
            self.loader?.stopAnimation()
        }
        if result{
            let lessonParser = LessonParser(target: target, stringData: stringContent)
            lessonParser.parse(completionHandler: { lesson in
                self.lesson.lessonContent = lesson
                self.contentView.attributedText = self.lesson.lessonContent.content.html2Attributed
            })
        } else {
            //Show error
            DispatchQueue.main.async {
                self.loader?.stopAnimation()
                let errorVC = ErrorAlertController()
                errorVC.isLoadingPhase = false
                errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: stringContent)
                errorVC.modalPresentationStyle = .overFullScreen
                self.target.present(errorVC, animated: true, completion: nil)
            }
        }
    }
}

