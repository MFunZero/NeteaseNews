//
//  Define.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/17.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import Foundation
import UIKit

let screen = UIScreen.mainScreen().bounds


// 接口
var appApi: String = "http://c.m.163.com/"
var headlinePrefixUrl = "nc/article/headline/"
var topicPrefixUrl = "nc/article/list/"


var subfixUrl = "from=toutiao&fn=1&prog=&rec=0&passport=5tdg6HXrirTEy0biZoenaOxu5Qgz9IwfxBMkTUgNz7o%3D&devId=3TIE%2FM11sm3rCEnIfJcWsWjUEeFxLvvfinRN5TbDsslCSzfgAejAPIwKGsIyPNcm&size=20&version=10.0&spever=false&net=wifi&lat=9nd8fuqh16Lj0GC%2FUnrchQ%3D%3D&lon=ASyy5wWcxxWdb9cehziyEw%3D%3D&ts=1466298503&sign=Z8rroSWQ7AwGywAZE1569gAKTUugRyUgQPzKqwFt1Hl48ErR02zJ6%2FKXOnxX046I&encryption=1&canal=appstore"
var photosetPrefixUrl = "http://ent.163.com/photoview"



let screenSize = UIScreen.mainScreen().bounds
let photoSetSizeHeight:CGFloat = 180.0

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension UIImage {
    convenience init(url:NSURL) {
        let data = NSData(contentsOfURL: url)
        self.init(data:data!)!
    }
}