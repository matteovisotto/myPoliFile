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
    
    
    
    
}
