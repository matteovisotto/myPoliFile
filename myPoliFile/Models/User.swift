//
//  User.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import Foundation

class User: NSObject {
    public static var mySelf = User()
        
    public var token: String = ""
    public var userId: Int = 0
    public var fullname: String = ""
    public var email: String = ""
    public var username: String = "10608623@polimi.it"
    public var profileImageURL: String = ""
}


