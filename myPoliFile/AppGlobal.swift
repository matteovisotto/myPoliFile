//
//  AppGlobal.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 13/09/21.
//

import Foundation
import UIKit

class AppGlobal {
    
    enum RunningType: String {
        case appStore = "App Store"
        case testFlight = "Test Flight"
        case debug = "Debug"
    }
    
    public static var runningType: AppGlobal.RunningType = .debug
    
    public static var appLanguage: String = Locale.current.identifier //Return value is like EN_en
    
    public static var currentCourse: String = "" {
        didSet{
            AppGlobal.currentCourseFolder = currentCourse.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "\n", with: "__")
        }
    }
    
    public static var currentCourseFolder:String = ""
    
    public static var currentModule: String = "" {
        didSet {
            AppGlobal.currentModuleFolder = currentModule.replacingOccurrences(of: " ", with: "_")
        }
    }
    
    public static var currentModuleFolder: String = ""
    
    public static func setAppRunningType() -> Void {
        #if DEBUG
        AppGlobal.runningType = .debug
        #else
        if Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" {
            AppGlobal.runningType = .testFlight
        } else {
            AppGlobal.runningType = .appStore
        }
        #endif
    }
    
}
