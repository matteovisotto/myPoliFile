//
//  Course.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 08/09/21.
//

import Foundation

class Course: NSObject {
    
    var courseId: Int = 0
    var fullname: String = ""
    var displayName: String = ""
    var category: Int = 0
    var isHidden: Bool = false
    var isFavourite: Bool = false
    
    var sections: [Section] = []
    
}
