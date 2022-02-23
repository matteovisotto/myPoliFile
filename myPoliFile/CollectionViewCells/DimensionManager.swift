//
//  DimensionManager.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 28/10/21.
//

import Foundation
import UIKit

class DimensionManager {
    public static func getCollectionViewCellDimention(width: CGFloat, numberOfElementInSmallestRow el: Int)->CGFloat {
        
        if (width>=1366){ //iPad 12.9inch landscape
            return CGFloat((width-(10*(2*CGFloat(el)+1))-10)/((2*CGFloat(el))+1))
        } else if(width >= 1024){ //iPad 12.9inch portrait
            return CGFloat((width-(10*2*CGFloat(el))-10)/(2*CGFloat(el)))
        } else if (width >= 834){ //iPad 11.0 & 10.5 portrait
            return CGFloat((width-(10*(CGFloat(el)+1))-10)/(1+CGFloat(el)))
        } else if (width >= 667 ){ //iPad 9.7 portrait or iPhone 6 or newer landscape
            return CGFloat((width-(10*CGFloat(el))-10)/CGFloat(el))
        } else {
            return CGFloat(width-20)
        }
    }
}
