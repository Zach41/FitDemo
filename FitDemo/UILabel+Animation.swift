//
//  UILabel+Animation.swift
//  FitDemo
//
//  Created by ZachZhang on 16/7/2.
//  Copyright © 2016年 ZachZhang. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func  animateAlpha(duration: Double, delay: Double) -> Void {
        if let text = text {
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            
            let originalColor = self.textColor
            
            dispatch_after(time, dispatch_get_main_queue()) {
                self.iterateAlpha(text, index: 0, delay: duration / Double(text.characters.count), font: self.font, color: originalColor)
            }
        }
    }
    
    private func iterateAlpha(text: NSString, index: Int, delay: Double, font: UIFont, color: UIColor) {
        let subStringToShow = text.substringToIndex(index)
        let subStringToHide = text.substringFromIndex(index)
        
        let showAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : color]
        let hideAttrubutes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.clearColor()]
        
        let showString = NSAttributedString(string: subStringToShow, attributes: showAttributes)
        let hideString = NSAttributedString(string: subStringToHide, attributes: hideAttrubutes)
        
        let resultString = NSMutableAttributedString()
        resultString.appendAttributedString(showString)
        resultString.appendAttributedString(hideString)
        
        self.attributedText = resultString
        
        if subStringToHide.characters.count != 0 {
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            
            dispatch_after(time, dispatch_get_main_queue()) {
                self.iterateAlpha(text, index: index+1, delay: delay, font: font, color: color)
            }
        }
    }
}
