//
//  UserParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

class UserParser {
    private var targetVC: UIViewController!
    private var stringData: String!
    
    init(target: UIViewController, stringData: String) {
        self.stringData = stringData
        self.targetVC = target
    }
    
    func parse(completionHandler: @escaping ()->()) {
        if let data = stringData.data(using: .utf8) {
            do {
                let people = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
                if let p = people {
                    if (p.count == 1) {
                        let person = p[0] as? [String:Any]
                        if let pr = person {
                            let userId: Int = pr["id"] as! Int
                            let fullname: String = pr["fullname"] as! String
                            let email: String = pr["email"] as! String
                            let profileImageURL = pr["profileimageurl"] as! String
                            AppData.mySelf.email = email
                            AppData.mySelf.fullname = fullname
                            AppData.mySelf.userId = userId
                            AppData.mySelf.profileImageURL = profileImageURL
                            completionHandler()
                            return
                        } else {
                            
                            DispatchQueue.main.async {
                                let errorVC = ErrorAlertController()
                                errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString("error.datareading", comment: "Data reading error"))
                                errorVC.modalPresentationStyle = .overFullScreen
                                self.targetVC.present(errorVC, animated: true, completion: nil)
                            }
                            return
                        }
                    } else {
                        
                        DispatchQueue.main.async {
                            let errorVC = ErrorAlertController()
                            errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString("error.userdata", comment: "User data error"))
                            errorVC.modalPresentationStyle = .overFullScreen
                            self.targetVC.present(errorVC, animated: true, completion: nil)
                        }
                        return
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
