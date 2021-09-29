//
//  WelcomeViewModel.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 25/09/21.
//

import Foundation
import UIKit

class WelcomeViewModel {
    
    private var target: UIViewController!
    
    required init(target: UIViewController){
        self.target = target
    }
    
    func performActionForPoliMiLogin(usingPersonalCode personalCode: String) {
        PreferenceManager.setPersonalCode(personalCode: personalCode)
        AppData.mySelf.username = personalCode + "@polimi.it"
        let loginVC = WebLoginViewController()
        target.navigationController?.pushViewController(loginVC, animated: true)
        loginVC.callback = { content in
            if let data = content.data(using: .utf8) {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                    if let token = dic?["token"] {
                        PreferenceManager.setToken(token: token)
                        AppData.mySelf.token = token
                        let loadignVC = LoadingViewController()
                        loadignVC.modalPresentationStyle = .fullScreen
                        self.target.present(loadignVC, animated: true, completion: nil)
                    } else {
                        let errorVC = ErrorAlertController()
                        errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString("error.nottoken", comment: "No Token"))
                        errorVC.modalPresentationStyle = .overFullScreen
                        self.target.present(errorVC, animated: true, completion: nil)
                    }
                } catch {
                    let errorVC = ErrorAlertController()
                    errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: error.localizedDescription)
                    errorVC.modalPresentationStyle = .overFullScreen
                    self.target.present(errorVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func performActionForTokenLogin(usingPersonalCode personalCode: String) {
        PreferenceManager.setPersonalCode(personalCode: personalCode)
        AppData.mySelf.username = personalCode + "@polimi.it"
        let tokenVC = TokenAlertViewController()
        tokenVC.modalPresentationStyle = .overFullScreen
        tokenVC.callback = {token in
            PreferenceManager.setToken(token: token)
            AppData.mySelf.token = token
            let parameter: [String:Any] = ["field":"username", "values[0]":AppData.mySelf.username]
            let p = LinkBuilder.prepareParameters(params: parameter)
            let url = LinkBuilder.build(serviceName: "core_user_get_users_by_field", withParameters: p)
            let userTask = TaskManager(url: URL(string: url)!)
            userTask.delegate = self
            userTask.execute()
        }
        self.target.present(tokenVC, animated: true, completion: nil)
    }
}

extension WelcomeViewModel: TaskManagerDelegate {
    func taskManager(taskManager: TaskManager, didFinishWith result: Bool, stringContent: String) {
        if result {
            if let data = stringContent.data(using: .utf8) {
                do {
                    let people = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
                    if let p = people {
                        if (p.count == 1) {
                            let person = p[0] as? [String:Any]
                            if let _ = person {
                                DispatchQueue.main.async {
                                    let loadignVC = LoadingViewController()
                                    loadignVC.modalPresentationStyle = .fullScreen
                                    self.target.present(loadignVC, animated: true, completion: nil)
                                }
                                return
                            }
                        }
                    }
                } catch {
                    
                }
            }
        }
            //Show error
            PreferenceManager.removeToken()
            PreferenceManager.removePersonalCode()
            DispatchQueue.main.async {
                let errorVC = ErrorAlertController()
                errorVC.isLoadingPhase = false
                errorVC.setContent(title: NSLocalizedString("global.error", comment: "Error"), message: NSLocalizedString("error.wrongcode", comment: "Invalid code"))
                errorVC.modalPresentationStyle = .overFullScreen
                self.target.present(errorVC, animated: true, completion: nil)
            }
        }
    
}
