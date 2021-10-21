//
//  MVTopMenuProtocols.swift
//  myListaSpesa
//
//  Created by Matteo Visotto on 16/10/2020.
//  Copyright © 2020 MatMac System. All rights reserved.
//

import UIKit
protocol MVTopMenuDataSource {
    func numberOfItemInMenu(topMenuView: MVTopMenuView) -> Int
    func topMenu(topMenuView: MVTopMenuView, titleForItemAtIndex itemIndex: Int) -> String
}

protocol MVTopMenuDelegate {
    func topMenu(topMenuView: MVTopMenuView, didSelectItemAtIndex itemIndex: Int)
}

extension MVTopMenuDelegate {
    func topMenu(topMenuView: MVTopMenuView, didSelectItemAtIndex itemIndex: Int) {}
}
