//
//  UIView+Extension.swift
//  DXDoctor
//
//  Created by wuliupai on 16/9/20.
//  Copyright © 2016年 wuliu. All rights reserved.
//

import UIKit

extension UIView {
    
    // x
    var yy_x : CGFloat {
        
        get {
            
            return frame.origin.x
        }
        
        set(newVal) {
            
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newVal
            frame                 = tmpFrame
        }
    }
    
    // y
    var yy_y : CGFloat {
        
        get {
            
            return frame.origin.y
        }
        
        set(newVal) {
            
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newVal
            frame                 = tmpFrame
        }
    }
    
    /// height
    var yy_height : CGFloat {
        
        get {
            
            return frame.size.height
        }
        
        set(newVal) {
            
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newVal
            frame                 = tmpFrame
        }
    }
    
    // width
    var yy_width : CGFloat {
        
        get {
            
            return frame.size.width
        }
        
        set(newVal) {
            
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newVal
            frame                 = tmpFrame
        }
    }
    
    // left
    var yy_left : CGFloat {
        
        get {
            
            return yy_x
        }
        
        set(newVal) {
            
            yy_x = newVal
        }
    }
    
    // right
    var yy_right : CGFloat {
        
        get {
            
            return yy_x + yy_width
        }
        
        set(newVal) {
            
            yy_x = newVal - yy_width
        }
    }
    
    // top
    var yy_top : CGFloat {
        
        get {
            
            return yy_y
        }
        
        set(newVal) {
            
            yy_y = newVal
        }
    }
    
    // bottom
    var yy_bottom : CGFloat {
        
        get {
            
            return yy_y + yy_height
        }
        
        set(newVal) {
            
            yy_y = newVal - yy_height
        }
    }
    
    var yy_centerX : CGFloat {
        
        get {
            
            return center.x
        }
        
        set(newVal) {
            
            center = CGPoint(x: newVal, y: center.y)
        }
    }
    
    var yy_centerY : CGFloat {
        
        get {
            
            return center.y
        }
        
        set(newVal) {
            
            center = CGPoint(x: center.x, y: newVal)
        }
    }
    
    var yy_middleX : CGFloat {
        
        get {
            
            return yy_width / 2
        }
    }
    
    var yy_middleY : CGFloat {
        
        get {
            
            return yy_height / 2
        }
    }
    
    var yy_middlePoint : CGPoint {
        
        get {
            
            return CGPoint(x: yy_middleX, y: yy_middleY)
        }
    }
}


