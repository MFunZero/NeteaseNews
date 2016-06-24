//
//  ADSPhotosetTableViewCell.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/19.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import UIKit

class SkipPhotosetTableViewCell: UITableViewCell {
    @IBOutlet weak var imageView1: UIImageView!

    var newsItem:NewsItem?{
        didSet{
            var imageViews: [UIImageView] = [imageView1,imageView2,imageView3]

            if let title = newsItem?.title {
                self.titleLabel.text = title
            }
            
            
            let url = newsItem?.imgsrc
            let data = NSData(contentsOfURL: NSURL(string: url!)!)
            let img = UIImage(data: data!)!
            imageViews[0].image = img
            if let extra = newsItem?.imgextra {
                var count = 1
                for item in extra {
                    if count >= 3{
                        break
                    }
                  let url = (item as! NSDictionary).objectForKey("imgsrc") as! String
                    let data = NSData(contentsOfURL: NSURL(string: url)!)
                    let img = UIImage(data: data!)!
                    imageViews[count].image = img
                    count += 1
                }
                
                
            }
            
            
            formatNewsItem(newsItem!)
        }
    }
    private var images:[UIImage]=[UIImage]()
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   override func drawRect(rect: CGRect) {
//        self.rightLabel.backgroundColor = UIColor.lightGrayColor()
//    self.rightLabel.clipsToBounds = true
//    self.rightLabel.layer.cornerRadius = 10
    }
    
    func formatNewsItem(item:NewsItem)
    {
        if let source = item.source {
            self.leftLabel.text = source
        }else if let tags = item.TAG{
            self.leftLabel.text = tags
        }
        
        
        if let replyCount = item.replyCount {
            if Int(replyCount) < 1000 {
                self.rightLabel.text = item.recSource
            }
            else {
                self.rightLabel.text = "\(replyCount)跟帖"
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
