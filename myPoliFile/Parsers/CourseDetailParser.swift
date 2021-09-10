//
//  CourseDetailParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import Foundation
import UIKit

class CourseDetailParser {
    
    enum Sections {
        case introduction
        case noticeBoard
        case materials
        case recordings
        case deliveries
        case undefined
    }
    
    enum Modules{
        case forum
        case announcement
        case url
        case folder
    }
    
    private var targetVC: UIViewController!
    private var stringData: String!
    private var course: Course!
    init(target: UIViewController, stringData: String, targetCourse: Course) {
        self.stringData = stringData
        self.targetVC = target
        self.course = targetCourse
    }
    
    func parse(completionHandler: @escaping ()->()) {
        if let data = stringData.data(using: .utf8) {
            do {
                let s = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
                if let sections = s {
                    for s in sections { //Iteration in sections
                        if let section = s as? [String: Any]{
                            let sectionName = section["name"] as! String
                            let sectionType = self.defineSectionType(name: sectionName)
                            let sectionModules = section["modules"] as! [[String: Any]]
                            switch sectionType {
                            case .noticeBoard:
                                parseNoticeBoard(content: sectionModules)
                                break
                            case .materials:
                                parseMaterials(content: sectionModules)
                                break
                            case .recordings:
                                parseRecordings(content: sectionModules)
                                break
                            default:
                                continue
                            }
                        } else {
                            DispatchQueue.main.async {
                                let errorVC = ErrorAlertController()
                                errorVC.setContent(title: "Error", message: "Unable to parse your personal data")
                                errorVC.modalPresentationStyle = .overFullScreen
                                self.targetVC.present(errorVC, animated: true, completion: nil)
                            }
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        completionHandler()
                    }
                } else {
                    DispatchQueue.main.async {
                        let errorVC = ErrorAlertController()
                        errorVC.setContent(title: "Error", message: "Unable to convert the received data")
                        errorVC.modalPresentationStyle = .overFullScreen
                        self.targetVC.present(errorVC, animated: true, completion: nil)
                    }
                    return
                }
            } catch {
                
                DispatchQueue.main.async {
                    let errorVC = ErrorAlertController()
                    errorVC.setContent(title: "Error", message: error.localizedDescription)
                    errorVC.modalPresentationStyle = .overFullScreen
                    self.targetVC.present(errorVC, animated: true, completion: nil)
                }
                return
            }
        }
    }
    
    private func defineSectionType(name: String)-> Sections {
        if(name.contains("Introduzione")){
            return .introduction
        } else if (name.contains("Bacheca")) {
            return .noticeBoard
        } else if (name.contains("Materiali")) {
            return .materials
        } else if (name.contains("Registrazioni")) {
            return .recordings
        } else if (name.contains("Consegne")) {
            return .deliveries
        } else {
            return .undefined
        }
    }
    
    private func parseNoticeBoard(content: [[String: Any]]) {
        course.forum = nil
        course.announcement = nil
        for m in content {
            let name = m["name"] as! String
            let modname = m["modname"] as! String
            if(name.contains("Annunci") && modname == "forum"){ //Announcement
                let forumId = m["instance"] as! Int
                let newAnn = Announcement()
                newAnn.forumId = forumId
                course.announcement = newAnn
                
            } else if (name.contains("Forum") && modname == "forum") { //Forum
                let forumId = m["instance"] as! Int
               let newForum = Forum()
                newForum.forumId = forumId
                course.forum = newForum
            }
        }
    }
    
    private func parseMaterials(content: [[String: Any]]) {
        for m in content {
            
        }
    }
    
    private func parseRecordings(content: [[String: Any]]) {
        course.recordings.removeAll()
        for m in content {
            let name = m["name"] as! String
            let modname = m["modname"] as! String
            if (name.contains("Recordings") && modname=="url"){
                if let contents =  m["contents"] as? [[String: Any]]{
                    for c in contents{
                        let type = c["type"] as! String
                        let name = c["filename"] as! String
                        let url = c["fileurl"] as! String
                        if (type == "url"){
                            let newRecording = Recording()
                            newRecording.name = name
                            newRecording.url = url
                            course.recordings.append(newRecording)
                        }
                    }
                }
            }
        }
    }
    
}
