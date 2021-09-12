//
//  AppDelegate.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        var rootVC: UIViewController!
        
        if(!PreferenceManager.isFileDefaultActionAvailable()){
            PreferenceManager.setFileDefaultAction(defaultAction: 2)
        }
        
        if(PreferenceManager.isTokenAvailable() && PreferenceManager.isPersonalCodeAvailable()){
            if let token = PreferenceManager.getToken(), let personalCode = PreferenceManager.getPersonalCode() {
                User.mySelf.token = token
                User.mySelf.username = personalCode+"@polimi.it"
                rootVC = LoadingViewController()
            } else {
                let navController = UINavigationController(rootViewController: WelcomeViewController())
                navController.navigationBar.isHidden = true
                rootVC = navController
            }
        } else {
            let navController = UINavigationController(rootViewController: WelcomeViewController())
            navController.navigationBar.isHidden = true
            rootVC = navController
        }
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }


}

