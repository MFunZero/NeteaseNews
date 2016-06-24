//
//  BaseSingleNewsViewController.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/22.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

class BaseSingleNewsViewController: UIViewController,WKNavigationDelegate {

    var newsItem:NewsItem?
    
    
    
    var webView:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(BaseSingleNewsViewController.back))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.lightGrayColor()
        
        let constraint = CGSize(width: 400,height: 200)
        if let str = newsItem!.replyCount {
        let content = "\(str)跟帖"
        let size = content.boundingRectWithSize(constraint, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: NSDictionary(object:UIFont.systemFontOfSize(11), forKey: NSFontAttributeName) as? [String : AnyObject] ,context: nil)
        
        let customView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width+40, height: 44))
            customView.layer.cornerRadius = 10
            customView.clipsToBounds = true
            customView.contentMode = UIViewContentMode.ScaleAspectFit
            customView.image = UIImage(named: "contentcell_comment_background_640")
            let replyCountLabel = UILabel(frame: customView.frame)
            replyCountLabel.text = content
            replyCountLabel.textAlignment = .Center
            
            customView.addSubview(replyCountLabel)
            
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customView)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(BaseSingleNewsViewController.loadCommentPage))
            customView.userInteractionEnabled = true
        customView.addGestureRecognizer(gesture)
        

            
            
        }
        
        
        loadData()
    }
    
    func loadCommentPage()
    {
        
    }
    
    func loadData()
    {
        let config = WKWebViewConfiguration()
        //加载本地js文件
        let scriptURL = NSBundle.mainBundle().pathForResource("myjs", ofType: "js")
        let scriptContent = try! String(contentsOfFile: scriptURL!, encoding: NSUTF8StringEncoding)
        
        
        let script = WKUserScript(source: scriptContent, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        
        config.userContentController.addUserScript(script)
        self.webView = WKWebView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height), configuration: config)
        self.webView.navigationDelegate = self
        
        self.view = webView
        
        if let url = newsItem?.url {
        webView.loadRequest(NSURLRequest(URL: NSURL(string:url)!))
        }
    }
    

    func back()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
