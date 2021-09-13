//
//  AppGlobal.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 13/09/21.
//

import Foundation
import UIKit

class AppGlobal {
    public static var currentCourse: String = "" {
        didSet{
            AppGlobal.currentCourseFolder = currentCourse.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "\n", with: "__")
        }
    }
    
    public static var currentCourseFolder:String = ""
    
    public static var currentModule: String = "" {
        didSet {
            AppGlobal.currentModuleFolder = currentModule.replacingOccurrences(of: " ", with: "_")
        }
    }
    
    public static var currentModuleFolder: String = ""
}
