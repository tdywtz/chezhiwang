//
//  TransitionSegmentView.swift
//  TransitionSegment
//
//  Created by wuliupai on 16/9/21.
//  Copyright © 2016年 wuliu. All rights reserved.
//

import UIKit

let widthAddition:CGFloat = 20.0
let heightAddtion:CGFloat = 0.0
let cornerRadius:CGFloat = 15

let tagAddition = 100


public struct SegmentConfigure {
    
    var textSelColor:UIColor
    
    var highlightColor:UIColor

    var titles:[String]
}


class TransitionSegmentView: UIView {


    fileprivate let screenWidth =   UIScreen.main.bounds.width

    var theConfigure: SegmentConfigure?{
        get{
            return nil
        }
        set (new){
          configure = nil
        }
    }

   var configure: SegmentConfigure!{
        didSet{
            self.configUI()
        }
    }
    
    typealias SegmentClosureType = (Int)->Void
    
    //闭包回调方法
    open var scrollClosure:SegmentClosureType?

    open  var attributed : NSMutableAttributedString?
    //字体非选中状态颜色
    fileprivate var textNorColor:UIColor = UIColor.white
    
    //字体大小
    fileprivate var textFont:CGFloat = 14.0
    
    //底部scrollview容器
    fileprivate var bottomContainer:UIScrollView?
    
    //高亮区域
    fileprivate var highlightView:UIView?
    
    //顶部scrollView容器
    fileprivate var topContainer:UIScrollView?
    
    
   public init(frame: CGRect,configure:SegmentConfigure) {
        
        super.init(frame:frame)
        
        self.configure = configure
  
        self.configUI()
    }

   override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public init(frame: CGRect, textSelColor: UIColor, highlightColor: UIColor, titles: [String]) {

        super.init(frame:frame)

        self.configure = SegmentConfigure.init(textSelColor: textSelColor, highlightColor: highlightColor, titles: titles)

          self.configUI()
    }


    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
   open func setSegmentConfigure(_ configure:SegmentConfigure){
        self.configure = configure
    }
    ///初始化UI
    func configUI() {
        
        let rect = CGRect(x:0,y:0,width:frame.width,height:frame.height)
        
        bottomContainer = UIScrollView.init(frame:rect)
        topContainer = UIScrollView.init(frame: rect)
        highlightView = UIView.init()
        highlightView?.layer.masksToBounds = false
        
        self.configScrollView()
        
        self.addSubview(bottomContainer!)
        bottomContainer?.addSubview(highlightView!)
        highlightView?.addSubview(topContainer!)
        
    }
    
    //初始化scrollview容器
    func configScrollView()  {
        
        
        for view in (bottomContainer?.subviews)! {
            
            if view .isEqual(highlightView) {
                return
            }else{
                view .removeFromSuperview()
            }
        }
        
        for view in (topContainer?.subviews)! {
            view .removeFromSuperview()
        }
        
        highlightView?.backgroundColor = configure.highlightColor
        self.createBottomLabels(bottomContainer!, titleArray: configure.titles,isHighlight:false)
        self.createBottomLabels(topContainer!, titleArray: configure.titles,isHighlight:true)
        
        
        
    }
    
    //对scrollview容器进行设置
    func createBottomLabels(_ scrollView:UIScrollView,titleArray:[String],isHighlight:Bool) {
        
        var firstX:CGFloat = 0
        scrollView.showsHorizontalScrollIndicator = false
        
        for index in 0..<titleArray.count{
            
            let title:NSString = titleArray[index] as NSString
            
            let dict = [NSFontAttributeName:UIFont.systemFont(ofSize: textFont)]
            //富文本自己算label宽度和高度
            let itemWidth = title.size(attributes: dict).width + widthAddition
            
            let label = UILabel.init()
            label.frame = CGRect(x:firstX,y:0,width:itemWidth,height:self.frame.height)
            label.text = title as String
            label.textAlignment = NSTextAlignment.center
            
            if isHighlight {
                
                label.font = UIFont.systemFont(ofSize:textFont+1)
                label.textColor = configure.textSelColor
                
            }else{
                
                label.font = UIFont.systemFont(ofSize:textFont)
                label.textColor = textNorColor
                label.isUserInteractionEnabled = true
                label.tag = index + tagAddition;
                
                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(tap))
                label.addGestureRecognizer(gesture)
                
                
                if index == 0 {
                    highlightView?.frame = label.frame
                    self.clipView(highlightView!)
                }
                
            }
            
            firstX += itemWidth
            scrollView.contentSize = CGSize(width:firstX,height:0)
            scrollView.addSubview(label)
            
        }
    }
    
    //设置闭包
    func setSegmentScrollClosure(_ tempClosure:@escaping SegmentClosureType) {
        
        self.scrollClosure = tempClosure
        
    }
    
    //点击手势方法
    func tap(_ sender:UITapGestureRecognizer) {
        
        let item:UILabel = sender.view as! UILabel
        let index = item.tag
        self.scrollClosure!(Int(index-100))
        
    }
    
    //scrollViewDidScroll调用
    func segmentWillMove(_ point:CGPoint) {
        
        let index = Int(point.x/screenWidth)
        let remainder = point.x/screenWidth - CGFloat(index)
        
        for view in (bottomContainer?.subviews)! {
            
            if index == (view.tag - tagAddition) {
                
                
                // 判断bottomContainer 是否需要移动
                var offsetx = view.center.x - screenWidth/2
                
                let offsetMax = (bottomContainer?.contentSize.width)! - screenWidth
                
                if offsetx < 0 {
                    offsetx = 0
                }else if offsetx > offsetMax{
                    
                    offsetx = offsetMax
                }
                let bottomPoint = CGPoint(x:offsetx,y:0)
                
                bottomContainer?.setContentOffset(bottomPoint, animated: false)
                
                //调整高亮区域的frame
                highlightView?.frame = view.frame
                highlightView?.yy_x = view.yy_x + view.frame.width*remainder
                
                //获取下一个label的宽度
                let nextView = bottomContainer?.subviews[index+1]
                highlightView?.yy_width = (nextView?.yy_width)!*remainder + view.yy_width * (1-remainder)
                
                
                //裁剪高亮区域
                self.clipView(highlightView!)
                
                let topPoint = CGPoint(x:((highlightView?.frame.minX)!), y:0)
                
                //移动topContainer
                topContainer?.setContentOffset(topPoint, animated: false)
                
            }
        }
    }
    
    
    //scrollViewDidEndScrollingAnimation方法调用
    func segmentDidEndMove(_ point:CGPoint)  {
        //四舍五入
        let index = lroundf(Float(point.x/screenWidth))
        
        for view in (bottomContainer?.subviews)! {
            
            if index == (view.tag - 100) {
                
                //调整高亮区域的frame
                highlightView?.frame = view.frame
                
                //移动topContainer
                topContainer?.contentOffset = CGPoint(x:((highlightView?.frame.minX)!), y:0)
                
                
                // 判断bottomContainer 是否需要移动
                var offsetx = view.yy_centerX - screenWidth/2
                
                let offsetMax = (bottomContainer?.contentSize.width)! - screenWidth
                
                if offsetx < 0 {
                    offsetx = 0
                }else if offsetx > offsetMax{
                    
                    offsetx = offsetMax
                }
                let bottomPoint = CGPoint(x:offsetx,y:0)
                
                bottomContainer?.setContentOffset(bottomPoint, animated: true)
                
            }
        }
        
    }
    
    //切割高亮区域
    func clipView(_ view:UIView)  {
        
       // let rect = CGRect(x:widthAddition/4,y:heightAddtion/4,width:view.yy_width-widthAddition/2,height:view.yy_height-heightAddtion/2)
         let rect =  CGRect(x:0,y:0,width:view.yy_width,height:view.yy_height)
        let bezierPath = UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius)
        let maskLayer = CAShapeLayer()

        maskLayer.path = bezierPath.cgPath
        view.layer.mask = maskLayer
        
        
    }

    
    

}
