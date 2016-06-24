//
//  PhotoSetTableViewCell.swift
//  NeteaseNews
//
//  Created by fanzz on 16/6/19.
//  Copyright © 2016年 fanzz. All rights reserved.
//

import UIKit



class PhotoSetTableViewCell: UITableViewCell ,UIScrollViewDelegate{
    
    
    var newsItem:PhotoSet?{
        didSet {
            if let ads = newsItem!.ads {
                self.images = ads
                let item = SinglePhoto.mj_objectWithKeyValues(images[0])
                textContent.text = item.title
                
//                self.setNeedsDisplay()
            }else if let extra = newsItem!.imgextra{
                
                    self.images = extra
                    let item = SinglePhoto.mj_objectWithKeyValues(images[0])
                    textContent.text = item.title
                
            }else{
                let item = SinglePhoto.mj_objectWithKeyValues(newsItem)
                self.images = [item]
                textContent.text = item.title

            }
        }
    }
    private var tagImageView:UIImageView = UIImageView()
    private var scrollView:UIScrollView = UIScrollView()
    private var imageViews:[UIImageView] = [UIImageView]()
    
    private var pagecontroll:UIPageControl = UIPageControl()
    private var bottomView:UIView = UIView()
    private var textContent:UILabel = UILabel()
    private var images:NSArray = NSArray()
    private var blurView:UIView = UIView()
    
    private var timer = NSTimer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    
    override func drawRect(rect: CGRect) {
        
        print("count:\(self.images.count)")
        //        self.scrollView.backgroundColor = UIColor.redColor()
        
        for i in 0..<images.count{
            //show pic scroll
            let imageVc = UIImageView()
            let imageX = CGFloat(i)*screenSize.width
            imageVc.frame = CGRectMake(imageX, 0, screenSize.width, photoSetSizeHeight)
            let item = SinglePhoto.mj_objectWithKeyValues(images[i])
            let nsd = NSData(contentsOfURL:NSURL(string: item.imgsrc!)!)
            imageVc.image = UIImage(data: nsd!)
            imageVc.backgroundColor = UIColor.cyanColor()
            self.scrollView.addSubview(imageVc)
        }
        self.scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: screenSize.width, height: photoSetSizeHeight))
        self.addSubview(scrollView)
        let contentSW = screenSize.width * CGFloat(images.count)
        self.scrollView.contentSize = CGSizeMake(contentSW, photoSetSizeHeight)
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        
        
        bottomView.frame = CGRect(x: 0, y: photoSetSizeHeight/6*5, width: screenSize.width, height: photoSetSizeHeight/6)
        self.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.clearColor()
        
        self.pagecontroll.frame = CGRectMake(screenSize.width-60, photoSetSizeHeight-photoSetSizeHeight/12 - 10, 30, 20)
        self.pagecontroll.currentPageIndicatorTintColor = UIColor.redColor()
        
        self.pagecontroll.pageIndicatorTintColor = UIColor.whiteColor()
        self.pagecontroll.currentPage = 0
        self.pagecontroll.numberOfPages = self.images.count
        if self.images.count > 1 {
        self.addSubview(self.pagecontroll)
        }
        let blurEffect: UIBlurEffect = UIBlurEffect(style: .Light)
        self.blurView = UIVisualEffectView(effect: blurEffect)
        
        let width = self.bottomView.frame.width
        self.blurView.frame = CGRect(x: 0, y: 0, width: width, height: self.bottomView.bounds.height)
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomView.addSubview(self.blurView)
        
        
        textContent.frame = CGRect(x: 40, y: 0, width: bottomView.frame.width - pagecontroll.frame.width - 65, height: bottomView.frame.height)
        self.bottomView.addSubview(textContent)
        
        self.textContent.font = UIFont(name: "Arial", size: 13)
        
        tagImageView.frame = CGRect(x: 0, y: -5, width: 40, height: photoSetSizeHeight/6+5)
        tagImageView.image = UIImage(named: "head_news_cell_category_background")
        self.bottomView.addSubview(tagImageView)
        
        let subLabel = UILabel(frame: CGRect(x: 0, y:photoSetSizeHeight/24+5, width: tagImageView.frame.width, height: photoSetSizeHeight/12))
        self.tagImageView.addSubview(subLabel)
        subLabel.text = "图集"
        subLabel.textAlignment = .Center
        subLabel.textColor = UIColor.whiteColor()
        subLabel.font = UIFont(name: "Arial", size: 12)
        self.addTimer()
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollviewW =  screenSize.width
        let page = Int(scrollView.contentOffset.x / scrollviewW)
        self.pagecontroll.currentPage = page
        
        guard page >= 0 && page < self.images.count else { return }
        
        let item = SinglePhoto.mj_objectWithKeyValues(images[page])
        self.textContent.text = item.title
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.removeTimer()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()
    }
    
    func addTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(PhotoSetTableViewCell.nextImage), userInfo: nil, repeats: true)
    }
    //关闭定时器
    func removeTimer(){
        self.timer.invalidate()
    }
    func nextImage(){
        var page = Int(self.pagecontroll.currentPage)
        //println(self.picArray.count)
        if (page == self.images.count-1){
            page = 0
        }else{
            page = page+1
        }
        self.scrollView.contentOffset = CGPointMake(CGFloat(page)*self.scrollView.frame.size.width, 0)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
