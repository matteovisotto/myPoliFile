//
//  WebpageBuilder.swift
//  myPoliFile
//
//  Created by Matteo Visotto on 16/09/21.
//

import Foundation
import UIKit

class WebpageBuilder {
    
    public static func preparePage(forForumDiscussion disc: Discussion, withReplies replies: [Discussion]) -> String {
        let header = "<html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><style media=\"screen\">  * {    font-family: Arial;  }  body {    padding-top: 10px;    width: 95%;    margin: auto;  }  .header {    width: 100%;    background-color: #315FDD;    height: 44px;  }  .header h3 {    margin: auto;    vertical-align: middle;    line-height:44px;    padding-left: 10px;    color: #ffffff;  } .reply {color: #315FDD;}</style></head><body>  <div class=\"header\">    <h3>" + disc.sender + "</h3>  </div></body></html>"
        
        let footer = "</body></html>"
        
        var finalString = header + disc.content
        for r in replies {
            finalString = finalString + "<hr/>" + "<h4 class=\"reply\">" + r.sender + "</h4>" + r.content
        }
        finalString = finalString + footer
        return finalString
    }
    
    public static func prepareNotificationPage(forNotification notification: Notification) -> String {
        let topPart = "<html> <head> <meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1'> <style media='screen'> * { font-family: Arial; } body { padding-top: 10px; width: 95%; margin: auto; } .header { width: 100%; background-color: #315FDD; height: 44px; } .header h3 { margin: auto; vertical-align: middle; line-height:44px; padding-left: 10px; color: #ffffff; } .reply { color: #315FDD; } </style> </head> <body> <div hidden>"
        
        let notificationScript = "<script type='text/javascript'>function pageLoader(){let title = document.getElementsByClassName('subject')[0].innerHTML.replace('\n', '').trim(); let author = document.getElementsByClassName('author')[0].getElementsByTagName('a')[0].innerText; let date = document.getElementsByClassName('author')[0].innerHTML.split('</a>'); date = date[date.length-1].split('-'); date = date[date.length-1].split('\n')[0].trim(); let text = document.getElementsByClassName('content')[0].innerText; document.getElementById('myTitle').innerHTML = title; document.getElementById('myAuthor').innerHTML = author; document.getElementById('myDate').innerHTML = date; document.getElementById('myText').innerHTML = text;}</script>"
        
        let bottomPart = "</div> <div class='header'> <h3 id='myTitle'></h3> </div> <p><span id='myAuthor'></span> (<span id='myDate'></span>)</p> <p id='myText'></p>" + notificationScript + "</body> </html>"
        
        return topPart + notification.htmlContent + bottomPart
    }
}
