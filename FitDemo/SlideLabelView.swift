//
//  SlideLabelView.swift
//  FitDemo
//
//  Created by ZachZhang on 16/7/2.
//  Copyright © 2016年 ZachZhang. All rights reserved.
//

import Foundation
import UIKit

class SlideLabelView : UIView {
    private let shiftDuration : NSTimeInterval = 0.7
    private let animateDuration : NSTimeInterval = 0.5
    
    private var label: UILabel  = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.Center
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.textColor = UIColor.blackColor()
        
        return label
    }()
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(label)
        label.hidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.bounds
        frame.origin.x = 40
        frame.size.width -= 80
        label.frame = frame
    }
    
    func animate(delay: NSTimeInterval) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        
        dispatch_after(time, dispatch_get_main_queue()) {
            self.label.hidden = false
        }
        
        let shiftAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        shiftAnimation.duration = shiftDuration
        shiftAnimation.fromValue = 50.0
        shiftAnimation.toValue = 0.0
        shiftAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        label.layer.addAnimation(shiftAnimation, forKey: "shift")
        
        label.animateAlpha(animateDuration, delay: delay)
    }
    
    
}
