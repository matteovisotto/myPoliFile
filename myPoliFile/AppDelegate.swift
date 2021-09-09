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
        //PreferenceManager.removeToken()
        if(PreferenceManager.isTokenAvailable()){
            if let token = PreferenceManager.getToken() {
                User.mySelf.token = token
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

