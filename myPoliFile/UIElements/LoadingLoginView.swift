//
//  LoadingLoginView.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 09/09/21.
//

import Foundation
import UIKit

class LoadingLoginView: UIView {
    private var geometricLoader = Loader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        geometricLoader = CircleLoader.createGeometricLoader()
        geometricLoader.startAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
