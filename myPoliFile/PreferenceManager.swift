//
//  PreferenceManager.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import Foundation
import UIKit

class PreferenceManager {
    
    // MARK:- Token
    public static func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "userToken")
    }
    
    public static func isTokenAvailable() -> Bool {
        let m = UserDefaults.standard
        if let _ = m.string(forKey: "userToken") {
            return true
        }
        return false
    }
    
    public static func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "userToken")
    }
    
    public static func removeToken() {
        UserDefaults.standard.removeObject(forKey: "userToken")
    }
    
    //MARK:- PoliMi Personal Code
    
    public static func setPersonalCode(personalCode: String) {
        UserDefaults.standard.setValue(personalCode, forKey: "polimiPersonalCode")
    }
    
    public static func isPersonalCodeAvailable() -> Bool {
        let m = UserDefaults.standard
        if let _ = m.string(forKey: "polimiPersonalCode") {
            return true
        }
        return false
    }
    
    public static func getPersonalCode() -> String? {
        return UserDefaults.standard.string(forKey: "polimiPersonalCode")
    }
    
    public static func removePersonalCode() {
        UserDefaults.standard.removeObject(forKey: "polimiPersonalCode")
    }
    
    //MARK:- File default action
    
    public static func setFileDefaultAction(defaultAction: Int) {
        UserDefaults.standard.setValue(defaultAction, forKey: "fileDefaultAction")
    }
    
    public static func isFileDefaultActionAvailable() -> Bool {
        let m = UserDefaults.standard
        if let _ = m.string(forKey: "fileDefaultAction") {
            return true
        }
        return false
    }
    
    public static func getFileDefaultAction() -> Int? {
        return UserDefaults.standard.integer(forKey: "fileDefaultAction")
    }
    
    public static func removeFileDefaultAction() {
        UserDefaults.standard.removeObject(forKey: "fileDefaultAction")
    }
    
    //MARK:- Courses Loading
    public static func setCoursesReloading(defaultAction: Bool) {
        UserDefaults.standard.setValue(defaultAction, forKey: "coursesReloading")
    }
    
    public static func isCoursesReloadingAvailable() -> Bool {
        let m = UserDefaults.standard
        if let _ = m.string(forKey: "coursesReloading") {
            return true
        }
        return false
    }
    
    public static func getCoursesReloading() -> Bool {
        return UserDefaults.standard.bool(forKey: "coursesReloading")
    }
    
    public static func removeCoursesReloading() {
        UserDefaults.standard.removeObject(forKey: "coursesReloading")
    }
    
    public static func setOldHidden(_ hidden: Bool) {
        UserDefaults.standard.setValue(hidden, forKey: "hideOld")
    }
    
    public static func getOldHidden() -> Bool {
        return UserDefaults.standard.bool(forKey: "hideOld")
    }
    
}
