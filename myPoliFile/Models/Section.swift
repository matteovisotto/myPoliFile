//
//  Section.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 10/09/21.
//

import Foundation
import UIKit

class Section {
    
    enum SectionType {
        case introduction
        case noticeBoard
        case materials
        case recordings
        case deliveries
        case undefined
    }
    
    var name: String = ""
    var content: [Module] = []
    var sectionType: SectionType = .undefined
    
    public static func defineSectionType(name: String)-> SectionType {
        if(name.contains("Introduzione")){
            return .introduction
        } else if (name.contains("Bacheca")) {
            return .noticeBoard
        } else if (name.contains("Materiali")) {
            return .materials
        } else if (name.contains("Registrazioni")) {
            return .recordings
        } else if (name.contains("Consegne")) {
            return .deliveries
        } else {
            return .undefined
        }
    }
}
