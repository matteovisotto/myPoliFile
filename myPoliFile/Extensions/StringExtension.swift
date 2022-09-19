//
//  StringExtension.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 11/09/21.
//

import Foundation
import UIKit

extension String {
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
   
}

//Testing purpose
extension UIColor {
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
}

extension String {
    var html2Attributed: NSAttributedString? {
        let h = "<style>table {  border: 1px solid #ccc;  border-collapse: collapse;  margin: 0;  padding: 0;  width: 100%;  table-layout: fixed;}table caption {  font-size: 1.5em;  margin: .5em 0 .75em;}table tr {  background-color: #f8f8f8;  border: 1px solid #ddd;  padding: .35em;}table th,table td {  padding: .625em;  text-align: center;}table th {  font-size: .85em;  letter-spacing: .1em;  text-transform: uppercase;}@media screen and (max-width: 600px) {  table {    border: 0;  }  table caption {    font-size: 1.3em;  }    table thead {    border: none;    clip: rect(0 0 0 0);    height: 1px;    margin: -1px;    overflow: hidden;    padding: 0;    position: absolute;    width: 1px;  }    table tr {    border-bottom: 3px solid #ddd;    display: block;    margin-bottom: .625em;  }    table td {    border-bottom: 1px solid #ddd;    display: block;    font-size: .8em;    text-align: right;  }    table td::before {    /*    * aria-label has no advantage, it won't be read inside a table    content: attr(aria-label);    */    content: attr(data-label);    float: left;    font-weight: bold;    text-transform: uppercase;  }    table td:last-child {    border-bottom: 0;  }}/* general styling */body {  font-family: \"Open Sans\", sans-serif;  line-height: 1.25;}</style> \(self)"
        do {
            guard let data = h.data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }

}
