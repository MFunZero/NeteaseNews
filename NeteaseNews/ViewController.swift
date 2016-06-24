//
//  ViewController.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/17.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SelectCellDelegate{
    
    var topics:[Topic] = [Topic]()
    var controllers:[AnyObject] = [AnyObject]()
    var buttonsTitles:[String] = [String]()
    
    @IBOutlet weak var swiftPagesView: SwiftPages!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Initiation
        do {
        let path = NSBundle.mainBundle().pathForResource("topic", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//        let dict = NSDictionary(contentsOfFile: path!)
        let dictArray = dict["tList"]
        dictArray?.enumerateObjectsUsingBlock({ (obj, index, flag) in
            let  topic:Topic = Topic.mj_objectWithKeyValues(obj)
            self.topics.append(topic)
        })
        }catch let error as NSError {
            print("error:\(error)")
        }
        self.title = "网易"
        let VCIDs = ["VC1", "VC2", "VC3", "VC4", "VC5","VC6"]
        let buttonTitles = ["头条", "娱乐", "体育", "财经", "科技","段子"]
        
        // Sample customization
       
        for item in self.topics {
            let vc = BaseTableViewController(topic: item)
            vc.delegate = self
            controllers.append(vc)
            buttonsTitles.append(item.tname!)
        }
      
        swiftPagesView.initializeWithVCArrayAndButtonTitlesArray(controllers, buttonTitlesArray: buttonsTitles)
        swiftPagesView.setOriginY(0.0)
        swiftPagesView.setButtonsTextColor(UIColor.blackColor())
        swiftPagesView.setBarButtonsCountInScreen(4)
        swiftPagesView.setAnimatedBarColor(UIColor.redColor())

        
        
    }
    func didSelectedCell(item: NewsItem,type:NewsType) {
        switch type {
        case .ADS:
            let vc = BaseSingleNewsViewController()
            vc.newsItem = item
            self.navigationController?.pushViewController(vc, animated: true)
        case .Mix:

            let vc = BaseSingleNewsViewController()
            vc.newsItem = item
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .PhoteSet:

            let vc = PhotosViewController()
            vc.newsItem = item
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .Text:

            let vc = BaseSingleNewsViewController()
            vc.newsItem = item
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

