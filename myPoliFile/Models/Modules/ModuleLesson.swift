//
//  ModuleLesson.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 18/09/22.
//

import Foundation
import UIKit

class ModuleLesson: Module {
    
    var lessonContent: Lesson = Lesson()
    
    required init() {
        super.init(modname: .lesson, icon: UIImage(named: "icon-lesson")!)
    }
}
