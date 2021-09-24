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
        case portrait = "Portrait"
        case landscape = "Landscape"
    }
    
    public static var runningType: AppGlobal.RunningType = .debug
    
    public static var deviceType: AppGlobal.DeviceType = .iPhone
    
    public static var deviceOrientation: AppGlobal.DeviceOrientation = .portrait
    
    public static var appLanguage: String = Locale.current.identifier //Return value is like EN_en
    
    public static var screenRect: CGRect = .zero {
        didSet{
            AppGlobal.setDeviceType(frame: screenRect)
        }
    }
    
    
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
    
    private static func setDeviceType(frame: CGRect) {
        let width = frame.width
        let height = frame.height
        
        if(width<=450 && height<=930) {
            AppGlobal.deviceType = .iPhone
            AppGlobal.deviceOrientation = .portrait
        } else if (height<=450 && width<=930) {
            AppGlobal.deviceType = .iPhone
            AppGlobal.deviceOrientation = .landscape
        } else if (height>760 && width>1020) {
            AppGlobal.deviceType = .iPad
            AppGlobal.deviceOrientation = .landscape
        } else {
            AppGlobal.deviceType = .iPad
            AppGlobal.deviceOrientation = .portrait
        }
        
        
    }
    
}
