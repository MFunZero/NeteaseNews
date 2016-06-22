//
//  NewsItem.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/19.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import UIKit

class NewsItem: NSObject {
    
    var boardid: String?
    var clkNum: String?
    var digest: String?
    var docid: String?
    var downTimes: String?
    var id: String?
    var img: String?
    var imgType: String?
    var imgsrc: String?
    var interest: String?
    var lmodify: String?
    var picCount: String?
    var program: String?
    var ptime: String?
    var recSource: String?
    var recType: String?
    var recprog: String?
    var replyCount: String?
    var replyid: String?
    var skipID: String?
    var skipType: String?
    var source: String?
    var specialID: String?
    var template: String?
    var title: String?
    var upTimes: String?
    
    var recReason:String?
    var url_3w:String?
    var postid:String?
    var hasCover:Bool?
    var hasHead:String?
    var votecount:String?
    var hasImg:String?
    var hasIcon:Bool?
    var order:String?
    var priority:String?
    var ltitle:String?
    var ads :NSArray?
    var photosetID:String?
    var alias:String?
    var cid:String?
    var hasAD:String?
    var imgextra:NSArray?
    var ename:String?
    var tname:String?
    
    var TAG:String?
    var TAGS:String?
    
    override var description: String {
        return "title:\(title);tname:\(tname);source:\(source)"
    }
}
