//
//  AppData.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 24/09/21.
//

import Foundation
import UIKit

//Global App Model
class AppData {
    //User selected course
    public static var currentCourse: String = "" {
        didSet{
            AppData.currentCourseFolder = currentCourse.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "\n", with: "__")
        }
    }
    
    //User selected course ad folder name
    public static var currentCourseFolder:String = ""
    
    //User selected module
    public static var currentModule: String = "" {
        didSet {
            AppData.currentModuleFolder = currentModule.replacingOccurrences(of: " ", with: "_")
        }
    }
    
    //User selected module as folder name
    public static var currentModuleFolder: String = ""
    
    //Logged user
    public static var mySelf = User()
    
    //Courses data
    public static var courses: [Course] = []
    public static var hiddenCourses: [Course] = []
    public static var favouriteCourses: [Course] = []
    
    //Categories
    public static var categories: [Category] = []
    
    //Notifications
    public static var notifications: [Notification] = []
    
    //Courses functions
    public static func clearCourses() {
        self.courses.removeAll()
        self.hiddenCourses.removeAll()
        self.favouriteCourses.removeAll()
    }
}
