//
//  Utils.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 15/09/22.
//

import Foundation
import UIKit

class Utils {
    
    public static func verifyIfAccademicYear(_ categoryName: String) -> Bool {
        let regex = "^([0-9]{4}[-]{1}[0-9]{2})$"
        if categoryName.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil {
            return true
        }
        return false
    }
    
    public static func isCurrentAccademicYear(_ categoryName: String) -> Bool{
        let startYear: String = categoryName.components(separatedBy: "-").first ?? ""
        let today = Date()
        if((Int(startYear) == today.getYear()) || (Int(startYear) ?? 0 == today.getYear()-1 && today.getMonth() <= 8)) {
            return true
        }
        return false
    }
    
}
