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
        if(PreferenceManager.isTokenAvailable()){
            if let token = PreferenceManager.getToken() {
                User.mySelf.token = token
                rootVC = LoadingViewController()
            } else {
                rootVC = WelcomeViewController()
            }
        } else {
            rootVC = WelcomeViewController()
        }
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }


}
