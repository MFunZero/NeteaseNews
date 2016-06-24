//
//  BaseTableViewController.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/18.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

enum NewsType {
    case PhoteSet,Text,Mix,ADS
}

protocol SelectCellDelegate {
    func didSelectedCell(item:NewsItem,type:NewsType)
}



private let photoSetCellIdentifier = "photoSetCellIdentifier"
private let hotTopicCellIdentifier = "hotTopicCellIdentifier"
private let skipPhotosetCellIdentifier = "skipPhotosetTableViewCell"
class BaseTableViewController: UITableViewController {
    
    var delegate:SelectCellDelegate?
    
    
    var dictArray:[NewsItem] = [NewsItem]()
    var pageSize:Int = 10
    var pageStart:Int = 0
    
    var topic:Topic = Topic()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
    }
    init(topic:Topic) {
        self.topic = topic
        super.init(style: UITableViewStyle.Plain)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func requestDataByTopic(top:Topic) {
        var urlString = appApi
        if top.tid == "T1348647853363" {
            urlString = urlString.stringByAppendingString( headlinePrefixUrl.stringByAppendingString("T1348647853363/0-10.html"))
            //            \(start)-\(end)
        }else{
            let id = "\(top.tid!)"
            urlString = urlString.stringByAppendingString( headlinePrefixUrl.stringByAppendingString("\(id)/0-10.html"))
        }
        
        Alamofire.request(.GET, urlString, parameters: nil)
            .responseJSON { response in
                print(response.request)
                switch response.result {
                case .Success:
                    //把得到的JSON数据转为数组
                    if let items = response.result.value as? NSDictionary{
                        //遍历数组得到每一个字典模型
                        let array = items[top.tid!] as! NSArray
                        print("items:\(array)")
                        var news = [NewsItem]()
                        
                        var c = 0
                        for item in array {
                            let newsItems = NewsItem.mj_objectWithKeyValues(item)
                            
                            print("newslll\(c):\(newsItems.title),count:\(array.count)")
                            news.append(newsItems)
                            c+=1
                        }
                        
                        self.dictArray = news
                        print("dictArray:\(self.dictArray)")

                        self.tableView.reloadData()
                        self.tableView.mj_header.endRefreshing()
                    }
                case .Failure(let error):
                    print(error)
                    self.tableView.mj_header.endRefreshing()

                }
        }
    }
    
    
    func loadMoreDataByTopic(top:Topic) {
        var urlString = appApi
        let start = pageStart * pageSize
        let end = start + pageSize
        if top.tid == "T1348647853363" {
            urlString = urlString.stringByAppendingString( headlinePrefixUrl.stringByAppendingString("T1348647853363/\(start)-\(end).html"))
            //            \(start)-\(end)
        }else{
            let id = "\(top.tid!)"
            urlString = urlString.stringByAppendingString( headlinePrefixUrl.stringByAppendingString("\(id)/\(start)-\(end).html"))
        }
        
        Alamofire.request(.GET, urlString, parameters: nil)
            .responseJSON { response in
                print(response.request)
                
                switch response.result {
                    
                case .Success:
                    //把得到的JSON数据转为数组
                    if let items = response.result.value as? NSDictionary{
                        //遍历数组得到每一个字典模型
                        let array = items[top.tid!] as! NSArray
                        print("items:\(array)")
                        
                        let start = self.dictArray.count
                        var new = [NewsItem]()
                        
                        var c = 0
                        for item in array {
                            if c != 0 {
                        
                
                            let newsItems = NewsItem.mj_objectWithKeyValues(item)
                            
                            print("newsiii:\(newsItems.title),count:\(self.dictArray.count)")
                            new.append(newsItems)
                            }
                            c+=1
                        }
                        self.dictArray.appendContentsOf(new)
                        
                        
                        print("dictArrayLoadMore:\(new)")
//                        self.tableView.reloadData()
                        self.tableView.beginUpdates()
                        
                        var indexPaths = [NSIndexPath]()
                        for i in start ..< self.dictArray.count {
                            let indexPath = NSIndexPath(forRow:i , inSection: 0)
                            indexPaths.append(indexPath)
                        }
                        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                        
                        self.tableView.endUpdates()
                        self.tableView.mj_footer.endRefreshing()
                    }
                case .Failure(let error):
                    print("error:\(error)")
                    self.tableView.mj_footer.endRefreshing()
                    let nowifiView = UIImageView(frame: self.tableView.frame)
                    self.tableView.addSubview(nowifiView)
                    nowifiView.center = self.tableView.center
                    nowifiView.image = UIImage(named: "publicWiFi_banner_icon_not_connected")
                    
                }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.autoresizingMask = .FlexibleHeight
        
        if self.dictArray.count == 0 {
            let header:MJRefreshNormalHeader = MJRefreshNormalHeader(refreshingBlock: { [unowned self]() -> Void in
                self.requestDataByTopic(self.topic)
                })
            self.tableView.mj_header = header
            
            header.setTitle("推荐中", forState: .Refreshing)
            header.setTitle("松开推荐", forState: .Pulling)
            header.setTitle("成功为您推荐10条内容", forState: MJRefreshState.Idle)
            
            self.tableView.mj_header.beginRefreshing()
            
            
        }
        
        
        
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.registerClass(PhotoSetTableViewCell.self, forCellReuseIdentifier: photoSetCellIdentifier)
        self.tableView.registerNib(UINib(nibName: "HotTopicTableViewCell",bundle: nil), forCellReuseIdentifier: hotTopicCellIdentifier)
        
        self.tableView.registerNib(UINib(nibName: "SkipPhotosetTableViewCell",bundle: nil), forCellReuseIdentifier: skipPhotosetCellIdentifier)
        setupRefresh()
        
    }
    
    func setupRefresh()
    {
        self.tableView.mj_footer = MJRefreshBackStateFooter (refreshingBlock:{ [unowned self]() -> Void in
            self.pageStart += 1
            self.loadMoreDataByTopic(self.topic)
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dictArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = self.dictArray[indexPath.row]
        if item.ads != nil {
            let cell = tableView.dequeueReusableCellWithIdentifier(photoSetCellIdentifier, forIndexPath: indexPath) as! PhotoSetTableViewCell
            
            cell.newsItem = PhotoSet.mj_objectWithKeyValues(item)
            return cell
        }else  if item.skipType == "photoset" {
            let cell = tableView.dequeueReusableCellWithIdentifier(skipPhotosetCellIdentifier, forIndexPath: indexPath) as! SkipPhotosetTableViewCell
            cell.newsItem = item
            cell.selectionStyle = UITableViewCellSelectionStyle.Gray
            print("urlCell:\(item.url)")
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier(hotTopicCellIdentifier, forIndexPath: indexPath) as! HotTopicTableViewCell
            cell.news = item
            cell.selectionStyle = UITableViewCellSelectionStyle.Gray
            print("urlCell:\(item.url)")
            return cell
            
        }
    }
    
    override  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.dictArray[indexPath.row]
        if item.ads != nil {
            print("didSelect:\(item.url)")
            self.delegate!.didSelectedCell(item,type: NewsType.Text)
        }else if item.skipType == "photoset" {
            self.delegate!.didSelectedCell(item,type: NewsType.PhoteSet)
        }else{
            self.delegate!.didSelectedCell(item,type: NewsType.Text)
        }
        //        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = self.dictArray[indexPath.row]
        print("hashead111:\(item.hasHead)")
        if item.ads != nil {
            return photoSetSizeHeight
        }else  if item.skipType == "photoset" {
            return photoSetSizeHeight
        }else{
            
            return photoSetSizeHeight/2
            
        }
    }
    
    
}
