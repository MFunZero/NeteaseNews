//
//  HotTopicTableViewCell.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/19.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import UIKit

class HotTopicTableViewCell: UITableViewCell {

    var news:NewsItem?{
        didSet{
            rightLabel.layer.cornerRadius = 30
            
            
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .ByCharWrapping
            titleLabel.font = UIFont.systemFontOfSize(14)
            //根据detailText文字长度调节topView高度
            let constraint = CGSize(width: titleLabel.frame.size.width,height: 100.0)
            let title = news!.title
            let size = title!.boundingRectWithSize(constraint, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: NSDictionary(object:UIFont.systemFontOfSize(14), forKey: NSFontAttributeName) as? [String : AnyObject] ,context: nil)
            
            titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y,size.width, size.height);//保持原来Label的位置和宽度，只是改变高度。
            titleLabel.text = title
            leftLabel.text = news?.interest
            
            if let data = NSData(contentsOfURL: NSURL(string: (news?.imgsrc)!)!) {
                imageV.image = UIImage(data: data,scale:1.5)
                imageV.frame.origin = CGPoint(x:0,y:0);
                imageV.contentMode = UIViewContentMode.ScaleAspectFit
            }
        }
    }
    
    private var blurView:UIVisualEffectView = UIVisualEffectView()
    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if let str = news!.replyCount {
            setRight("\(str)跟帖")
        }
    }

    func setRight(str:String)
    {

        let constraint = CGSize(width: rightLabel.frame.size.width,height: rightLabel.frame.height)
        
        let size = str.boundingRectWithSize(constraint, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: NSDictionary(object:UIFont.systemFontOfSize(14), forKey: NSFontAttributeName) as? [String : AnyObject] ,context: nil)
        
        rightLabel.frame = CGRectMake(rightLabel.frame.width-size.width+rightLabel.frame.origin.x, 0,size.width, rightLabel.frame.height)
        rightLabel.backgroundColor = UIColor.lightGrayColor()
        rightLabel.textColor = UIColor.grayColor()
        rightLabel.text = str

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
