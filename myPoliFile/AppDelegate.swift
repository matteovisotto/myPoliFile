//
//  AppDelegate.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit
import QuickLook

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppGlobal.screenRect = UIScreen.main.bounds
        AppGlobal.setAppRunningType()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        var rootVC: UIViewController!
        
        //Initialize "Default File Action" properties
        if(!PreferenceManager.isFileDefaultActionAvailable()){
            PreferenceManager.setFileDefaultAction(defaultAction: 2)
        }
        
        if(PreferenceManager.isTokenAvailable() && PreferenceManager.isPersonalCodeAvailable()){
            if let token = PreferenceManager.getToken(), let personalCode = PreferenceManager.getPersonalCode() {
                AppData.mySelf.token = token
                AppData.mySelf.username = personalCode+"@polimi.it"
                rootVC = LoadingViewController()
            } else {
                rootVC = loadWelcomeView(forDeviceType: AppGlobal.deviceType)
            }
        } else {
            rootVC = loadWelcomeView(forDeviceType: AppGlobal.deviceType)
        }
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }
    
    private func loadWelcomeView(forDeviceType type: AppGlobal.DeviceType) -> UIViewController {
        let vc: UIViewController
        switch type{
        case .iPad:
            vc = WelcomeIPadViewController()
            //vc = WelcomeViewController()
        case .iPhone:
            vc = WelcomeViewController()
        }
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        return navController
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if AppGlobal.deviceType == .iPad {
            return .all
        }
        
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            
            let currentVC = navigationController.visibleViewController
                                
               if (currentVC is FileViewerViewController || currentVC is AppQLPreviewController ){
                   return .all
               }

               // Else only allow the window to support portrait orientation
               else {
                   return .portrait
               }
           }

           // If the root view controller hasn't been set yet, just
           // return anything
        return .portrait
    }
}

