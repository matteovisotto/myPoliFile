//
//  LinkBuilder.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import Foundation

class LinkBuilder {
    
    enum OutputFormat: String {
        case json = "json"
        case xml = "xml"
    }
    
    public static let siteURL: String = "https://webeep.polimi.it/"
    public static let webserver: String = "webservice/rest/server.php"
    
    public static func build(serviceName: String) -> String{
        return LinkBuilder.build(serviceName: serviceName, withParameters: nil, returnMethod: .json)
    }
    
    public static func build(serviceName: String, withParameters params: String?) -> String{
        return LinkBuilder.build(serviceName: serviceName, withParameters: params, returnMethod: .json)
    }
    
    public static func build(serviceName: String, returnMethod: LinkBuilder.OutputFormat) -> String {
        return LinkBuilder.build(serviceName: serviceName, withParameters: nil, returnMethod: returnMethod)
    }
    
    public static func build(serviceName: String, withParameters params: String?, returnMethod: LinkBuilder.OutputFormat) -> String {
        var url: String = siteURL
        url = url + webserver + "?moodlewsrestformat="+returnMethod.rawValue+"&wstoken="+User.mySelf.token+"&wsfunction="+serviceName+"&"+(params ?? "")
        return url
    }
    
    public static func prepareParameters(params: [String:Any]) -> String {
        var par: String = ""
        for x in params {
            par = par + x.key + "=" + String(describing: x.value) + "&"
        }
        par = String(describing: par.dropLast())
        return par
    }
}
