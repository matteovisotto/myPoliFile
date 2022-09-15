//
//  DateExtension.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 15/09/22.
//

import Foundation
import UIKit

extension Date {
    
    func getYear() -> Int {
        let formatter = DateFormatter()
        formatter.locale = Calendar.current.locale
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = "y"
        return Int(formatter.string(from: self)) ?? 0
    }
    
    func getMonth() -> Int {
        let formatter = DateFormatter()
        formatter.locale = Calendar.current.locale
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = "M"
        return Int(formatter.string(from: self)) ?? 0
    }
    
    func getDay() -> Int {
        let formatter = DateFormatter()
        formatter.locale = Calendar.current.locale
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = "d"
        return Int(formatter.string(from: self)) ?? 0
    }
    
}
