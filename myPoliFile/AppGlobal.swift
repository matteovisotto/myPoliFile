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
    
    enum DeviceType: String {
        case iPhone = "iPhone"
        case iPad = "iPad"
    }
    
    enum DeviceOrientation: String {
        case portrait
        case landscape
    }
    
    public static var runningType: AppGlobal.RunningType = .debug
    
    public static var appLanguage: String = Locale.current.identifier //Return value is like EN_en
    
    
    
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
