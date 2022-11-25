//
//  StringParser.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 24/09/21.
//

import Foundation
import UIKit

class StringParser {
    public static func getTranslationFromTag(text: String) -> String{
        if(!text.contains("{mlang")){
            return text
        }
        let strings = text.components(separatedBy: "}{mlang ")
        var engText: String = ""
        for s in strings {
            var x = s.replacingOccurrences(of: "{mlang", with: "")
            if(x.first != nil && x.first == " "){
                x.removeFirst()
            }
            let langTag = String(x.prefix(2))
            let txt = x.replacingOccurrences(of: langTag+"}", with: "")
            if(AppGlobal.appLanguage.contains(langTag)){
                return txt.replacingOccurrences(of: "}", with: "")
            } else if (langTag == "en"){
                engText = txt.replacingOccurrences(of: "}", with: "")
            }
        }
        return engText
    }
    
    public static func parseCourseName(_ text: String) -> CourseName{
        let cName = CourseName()
        if (text.contains("{mlang}")){
            cName.courseName = StringParser.getTranslationFromTag(text: text)
            return cName
        } else if (text.range(of: "^[0-9]{4}", options: .regularExpression) != nil && text.contains("-")){
            var divided = text.split(separator: "-")
            cName.courseNumber = divided[0].replacingOccurrences(of: " ", with: "")
            divided.remove(at: 0)
            var fullCourseName = ""
            for s in divided {
                fullCourseName = fullCourseName + s
            }
            let secondDivision = fullCourseName.split(separator: "(")
            if secondDivision.count >= 2 {
                let courseName = secondDivision[0]
                let courseProf = secondDivision[1].replacingOccurrences(of: ")", with: "")
                cName.courseName = String(courseName).trimmingCharacters(in: .whitespacesAndNewlines)
                cName.courseProf = courseProf.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "(\\[[0-9]{6}\\])", with: "", options: .regularExpression)
                return cName
            }
            cName.courseName = String(fullCourseName).trimmingCharacters(in: .whitespacesAndNewlines)
            return cName
        }
        cName.courseName = text
        return cName
    }
}
