//
//  TopicTableViewController.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/20.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import UIKit

class TopicTableViewController: BaseTableViewController {

    override init(topic: Topic) {
        super.init(topic: topic)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestDataByTopic(self.topic)
        
    }
    
}
