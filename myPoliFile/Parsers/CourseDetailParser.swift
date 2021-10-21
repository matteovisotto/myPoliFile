//
//  CourseDetailParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import Foundation
import UIKit

class CourseDetailParser {
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
                    for s in sections {
                        if let section = s as? [String: Any]{
                            let sectionName = StringParser.getTranslationFromTag(text: section["name"] as! String)
                            let sectionType = Section.defineSectionType(name: sectionName)
                            let sectionModules = section["modules"] as! [[String: Any]]
                            let newSection = Section()
                            newSection.name = sectionName
                            newSection.sectionType = sectionType
                            for m in sectionModules {
                                let modname = m["modname"] as! String
                                let modnameEnum = Module.defineModname(modname: modname)
                                let instance = m["instance"] as! Int
                                let name = StringParser.getTranslationFromTag(text: m["name"] as! String)
                                var module: Module!
                                
                                switch modnameEnum {
                                case .url:
                                    module = ModuleURL()
                                    let mod = module as! ModuleURL
                                    mod.instance = instance
                                    mod.contents = ModuleURL.parseContent(content: m["contents"] as! [[String : Any]])
                                    mod.name = name
                                    break
                                case .folder:
                                    module = ModuleFolder()
                                    let mod = module as! ModuleFolder
                                    mod.instance = instance
                                    mod.contents = ModuleFolder.parseContent(content: m["contents"] as! [[String : Any]])
                                    mod.name = name
                                    break
                                case .forum:
                                    module = ModuleForum()
                                    module.instance = instance
                                    module.name = name
                                    break
                                case .label:
                                    module = ModuleLabel()
                                    module.instance = instance
                                    module.name = name
                                    break
                                case .resource:
                                    module = ModuleResource()
                                    let mod = module as! ModuleResource
                                    mod.instance = instance
                                    mod.contents = ModuleResource.parseContent(content: m["contents"] as! [[String : Any]])
                                    mod.name = name
                                    break
                                default:
                                    module = Module(modname: .undefined, icon: UIImage(named: "icon-undefined") ?? UIImage())
                                    module.instance = instance
                                    module.name = name
                                }
                                newSection.content.append(module)
                            }
                            course.sections.append(newSection)
                        } else {
                            DispatchQueue.main.async {
                                let errorVC = ErrorAlertController()
                                errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString("error.datareading", comment: "Data reading error"))
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
                        errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString("error.dataconversion", comment: "Data conversion error"))
                        errorVC.modalPresentationStyle = .overFullScreen
                        self.targetVC.present(errorVC, animated: true, completion: nil)
                    }
                    return
                }
            } catch {
                
                DispatchQueue.main.async {
                    let errorVC = ErrorAlertController()
                    errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: error.localizedDescription)
                    errorVC.modalPresentationStyle = .overFullScreen
                    self.targetVC.present(errorVC, animated: true, completion: nil)
                }
                return
            }
        }
    }
    
    
}
