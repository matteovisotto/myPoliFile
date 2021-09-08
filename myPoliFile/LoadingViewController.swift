//
//  LoadingViewController.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import UIKit

class LoadingViewController: BaseViewController {

    private var userInfoURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parameter: [String:Any] = ["field":"username", "values[0]":User.mySelf.username]
        let p = LinkBuilder.prepareParameters(params: parameter)
        self.userInfoURL = LinkBuilder.build(serviceName: "core_user_get_users_by_field", withParameters: p)
        test()
    }
    
    func test(){
        let req = URLRequest(url: URL(string: userInfoURL)!)
        let t = URLSession.shared.dataTask(with: req) { d, r, e in
            let c: String = String(data: d!, encoding: .utf8) ?? "Error"
            print(c)
        }
        t.resume()
    }

}
