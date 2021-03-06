//
//  Category.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation


class Category {
    
    var categoryId: Int = 0
    var categoryName: String = ""
    
    public static func getCategoryById(categoryId: Int) -> Category?{
        for c in AppData.categories {
            if(c.categoryId == categoryId){
                return c
            }
        }
        return nil
    }
    
}
