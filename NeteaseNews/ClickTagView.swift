//
//  ClickTagView.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/20.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import UIKit

class ClickTagView: UIView {

    var image:UIImage? {
        didSet{
            self.imageView.image = image
        }
    }
    var count:Int?{
        didSet {
            self.countLabel.text = "\(count)"
        }
    }
    private var imageView:UIImageView = UIImageView()
    private var countLabel:UILabel = UILabel()
    
    
    override func drawRect(rect: CGRect) {
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width/3, height: self.frame.height)
        self.addSubview(imageView)
        
        countLabel.frame = CGRect(x: imageView.frame.width + 10, y: 0.0, width: self.frame.width/3*2-20, height: self.frame.height)
        self.addSubview(countLabel)
        
        
        
    
    }


}
