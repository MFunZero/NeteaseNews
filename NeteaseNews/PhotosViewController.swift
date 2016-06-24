//
//  PhotosViewController.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/23.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import UIKit
import Alamofire
import WebKit

class PhotosViewController: UIViewController,WKNavigationDelegate {

    
    var newsItem:NewsItem?
    
    
    @IBOutlet weak var totalCount: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var textcontentLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    var webView:WKWebView!

    
    private var imageViews: [UIImageView] = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        setupWebView()
        
//        requestData()
        
        // Do any additional setup after loading the view.
    }
    
    func setupWebView()
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
        
        var urlString = photosetPrefixUrl

        var strs:[String]?
        if let photosetID = newsItem?.photosetID {
        strs = photosetID.componentsSeparatedByString("|")
        }else if let skipID = newsItem?.skipID {
            strs = skipID.componentsSeparatedByString("|")
        }
        for item in strs! {
            urlString += "/\(item)"
            
        }
        urlString += ".html"
        print("urlS:\(urlString)")
        webView.loadRequest(NSURLRequest(URL: NSURL(string:urlString)!))
    
    }

    func requestData()
    {
        let strs = newsItem?.skipID?.componentsSeparatedByString("|")
        var urlString = photosetPrefixUrl
        for item in strs! {
            urlString += "/\(item)"
        }
        Alamofire.request(.GET, urlString)
        .responseJSON{ response in
            print(response.request)
            
            switch response.result {
                
            case .Success:
                //把得到的JSON数据转为数组
                if let items = response.result.value as? NSDictionary {
                    
                }
            case .Failure(let error):
                print("error:\(error)")
                
                
            }
        }
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
