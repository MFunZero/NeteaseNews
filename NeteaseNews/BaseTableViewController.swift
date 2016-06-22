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

private let photoSetCellIdentifier = "photoSetCellIdentifier"
private let hotTopicCellIdentifier = "hotTopicCellIdentifier"

class BaseTableViewController: UITableViewController {
    
    var dictArray:[AnyObject] = [AnyObject]()
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
            urlString = urlString.stringByAppendingString( headlinePrefixUrl.stringByAppendingString("T1348647853363/0-10.html?")).stringByAppendingString(subfixUrl)
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
//                        let items = NewsItem.mj_objectArrayWithKeyValuesArray(array)
                        
                        
                        for item in array {
                            let newsItems = NewsItem.mj_objectWithKeyValues(item)
                            
                            print("newsiii:\(newsItems),count:\(array.count)")
                            self.dictArray.append(newsItems)
                            
                        }
                        self.tableView.reloadData()
                        self.tableView.mj_header.endRefreshing()
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    
    func loadMoreDataByTopic(top:Topic) {
        var urlString = appApi
        let start = pageStart * pageSize
        let end = start + pageSize
        if top.tid == "T1348647853363" {
            urlString = urlString.stringByAppendingString( headlinePrefixUrl.stringByAppendingString("T1348647853363/\(start)-\(end).html?")).stringByAppendingString(subfixUrl)
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
                        
//                        let pset = PhotoSet.mj_objectWithKeyValues(newsItems[0])
                        
                        let start = self.dictArray.count
                        for item in array {
                            let newsItems = NewsItem.mj_objectWithKeyValues(item)

                            print("newsiii:\(newsItems.title),count:\(array.count)")
                            self.dictArray.append(newsItems)

                        }
                        var count = 0
                        for index in self.dictArray {
                            print("count\(count):::\((index as! NewsItem).title)")
                            count += 1
                        }
                        self.tableView.reloadData()
//                        self.tableView.beginUpdates()
//                        
//                        var indexPaths = [NSIndexPath]()
//                        for i in start ..< self.dictArray.count {
//                            let indexPath = NSIndexPath(forRow:i , inSection: 0)
//                            indexPaths.append(indexPath)
//                        }
//                        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
//                        
//                        self.tableView.endUpdates()
                        self.tableView.mj_footer.endRefreshing()
                    }
                case .Failure(let error):
                    print(error)
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
        let item = self.dictArray[indexPath.row] as! NewsItem
        print("hashead111:\(item.hasHead)")
        if item.hasHead == "1" {
            let cell = tableView.dequeueReusableCellWithIdentifier(photoSetCellIdentifier, forIndexPath: indexPath) as! PhotoSetTableViewCell
            
            cell.newsItem = PhotoSet.mj_objectWithKeyValues(item)
            cell.textLabel?.text = "\(indexPath.row)::\(cell.newsItem?.title)"
            return cell
        }else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(hotTopicCellIdentifier, forIndexPath: indexPath) as! HotTopicTableViewCell
            cell.news = item
//            cell.textLabel?.text = "\(indexPath.row)::\(cell.news?.title)"

            
            return cell
        
    }
}

override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let item = self.dictArray[indexPath.row] as! NewsItem
    print("hashead111:\(item.hasHead)")
    if item.hasHead == "1" {
        return photoSetSizeHeight
    }else {
        return 100
    }
}

/*
 // Override to support conditional editing of the table view.
 override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
 if editingStyle == .Delete {
 // Delete the row from the data source
 tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
 } else if editingStyle == .Insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

}
