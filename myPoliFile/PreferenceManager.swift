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
    
    
    
}
