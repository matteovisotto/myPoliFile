//
//  ErrorParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

enum LoadingError: String {
    case invalidToken = "error.web.invalidToken"
    case generic = "error.web.generic"
}

class ErrorParser {
    private var targetVC: UIViewController!
    private var stringData: String!
    
    init(target: UIViewController, stringData: String) {
        self.stringData = stringData
        self.targetVC = target
    }
    
    func getError() -> LoadingError? {
        if let data = stringData.data(using: .utf8) {
            do {
                let error = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                guard let _ = error["exception"] as? String else {return nil}
                if let errorType = error["errorcode"] as? String {
                    if errorType == "invalidtoken" {
                        return .invalidToken
                    }
                    
                    return .generic
                } else {
                    return .generic
                }
            } catch {
                return nil
            }
        }
        
        return .generic
    }
}

