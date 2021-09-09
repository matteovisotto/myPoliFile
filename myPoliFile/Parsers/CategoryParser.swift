//
//  CategoryParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

class CategoryParser {
    
    private var targetVC: UIViewController!
    private var stringData: String!
    
    init(target: UIViewController, stringData: String) {
        self.stringData = stringData
        self.targetVC = target
    }
    
    func parse(completionHandler: @escaping ()->()) {
        if let data = stringData.data(using: .utf8) {
            do {
                let categories = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
                if let cts = categories {
                    for c in cts {
                        let cat = c as? [String:Any]
                        if let category = cat {
                            let categoryId = category["id"] as! Int
                            let categoryName = category["name"] as! String
                            let ct = Category()
                            ct.categoryId = categoryId
                            ct.categoryName = categoryName
                            Category.categories.append(ct)
                        } else {
                            DispatchQueue.main.async {
                                let errorVC = ErrorAlertController()
                                errorVC.setContent(title: "Error", message: "Unable to parse category data")
                                errorVC.modalPresentationStyle = .overFullScreen
                                self.targetVC.present(errorVC, animated: true, completion: nil)
                            }
                            return
                        }
                    }
                    DispatchQueue.main.async {
                        //Go to main app
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
}
