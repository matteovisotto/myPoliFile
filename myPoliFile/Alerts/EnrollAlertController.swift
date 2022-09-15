//
//  EnrollAlertController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 29/09/21.
//

import Foundation
import UIKit

class EnrollAlertController: AlertViewController {
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let cancelButton = AppButton()
    private let confirmButton = AppButton()
    open var callback: (_ result: Bool) -> () = {_ in}
    open var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
    }
    
    private func setupLayouts() {
        alertView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        titleLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.textAlignment = .center
        titleLabel.text = NSLocalizedString("enroll.enrollment", comment: "Enrollment")
        
        alertView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        messageLabel.text = NSLocalizedString("enroll.message", comment: "Insert token")
        messageLabel.numberOfLines = .zero
        
        
        
        let stackView = UIStackView()
        alertView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10).isActive = true
        stackView.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 33).isActive = true
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        cancelButton.normalColor = .systemRed
        cancelButton.highlightedColor = .systemOrange
        
        cancelButton.setTitle(NSLocalizedString("global.cancel", comment: "Cancel"), for: .normal)
        confirmButton.setTitle(NSLocalizedString("enroll.enroll", comment: "Enroll"), for: .normal)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(confirmButton)
        
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(didTapEnroll), for: .touchUpInside)
    }
    
    @objc private func didTapCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapEnroll() {
        askEnrollment()
    }
    
    private func askEnrollment(){
        let parameter:[String: Any] = ["courseid":self.course.courseId]
        let link = LinkBuilder.build(serviceName: "enrol_self_enrol_user", withParameters: LinkBuilder.prepareParameters(params: parameter))
        let task = TaskManager(url: URL(string: link)!)
        task.delegate = self
        task.execute()
    }
}

extension EnrollAlertController: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        DispatchQueue.main.async {
            if(result){
                if let data = stringContent.data(using: .utf8) {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                        if let r = result {
                            let status = r["status"] as? Bool
                            if let s = status {
                                if (s) {
                                    self.dismiss(animated: true, completion: nil)
                                    self.callback(true)
                                    return
                                }
                                self.dismiss(animated: true, completion: nil)
                                self.callback(false)
                                return
                            } else {
                                self.dismiss(animated: true, completion: nil)
                                self.callback(false)
                                return
                            }
                        } else {
                            self.dismiss(animated: true, completion: nil)
                            self.callback(false)
                            return
                        }
                    } catch {
                        self.dismiss(animated: true, completion: nil)
                        self.callback(false)
                        return
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
            self.callback(false)
        }
    }
}
