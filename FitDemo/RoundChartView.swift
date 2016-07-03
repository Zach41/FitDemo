//
//  RoundChartView.swift
//  FitDemo
//
//  Created by ZachZhang on 16/7/2.
//  Copyright © 2016年 ZachZhang. All rights reserved.
//

import Foundation
import UIKit

class RoundChartView: UIView {
    private let easeOut = CAMediaTimingFunction(controlPoints: 0, 0.4, 0.4, 1.0)
    private let greyChart : CAShapeLayer = {
        let greyChart = CAShapeLayer()
        greyChart.position = CGPointZero
        greyChart.lineCap = kCALineCapRound
        greyChart.fillColor = UIColor.clearColor().CGColor
        greyChart.strokeColor = UIColor.lightGrayColor().CGColor
        greyChart.strokeEnd = 0
        
        return greyChart
    }()
    
    private let colorChart : CAShapeLayer = {
        let circle = CAShapeLayer()
        circle.position = CGPointZero
        circle.lineCap  = kCALineCapRound
        circle.fillColor = UIColor.clearColor().CGColor
        circle.strokeColor = UIColor.blueColor().CGColor
        circle.strokeEnd = 0
        
        return circle
    }()
    
    var charColor : UIColor {
        get {
            return UIColor(CGColor: colorChart.strokeColor!)
        } set {
            colorChart.strokeColor = newValue.CGColor
        }
    }
    
    var chartThickness : CGFloat = 0.0 {
        didSet {
            greyChart.lineWidth = chartThickness
            colorChart.lineWidth = chartThickness
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.addSublayer(greyChart)
        self.layer.addSublayer(colorChart)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: frame.size.width / 2.0).CGPath
        greyChart.path = path
        colorChart.path = path
    }
    
    func show(percentage: Int, delay: NSTimeInterval) {
        let showTime : NSTimeInterval = 0.8
        
        let colorChartShow = animate(percentage, duration: 0.6, timingFunction: easeOut)
        colorChartShow.beginTime = delay
        
        let splashDuration : NSTimeInterval = 0.2
        let splashToValue = min(100, percentage+10)
        let splashChartShow = animate(splashToValue, duration: splashDuration, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        splashChartShow.beginTime = colorChartShow.beginTime + colorChartShow.duration + showTime

        let colorHide = animate(-1, duration: 0.3, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        colorHide.beginTime = splashChartShow.beginTime + splashChartShow.duration
        
        let colorGroup: CAAnimationGroup = CAAnimationGroup()
        colorGroup.duration = delay + colorChartShow.duration + showTime + splashChartShow.duration + colorHide.duration
        colorGroup.animations = [colorChartShow, splashChartShow, colorHide]
        colorGroup.fillMode = kCAFillModeForwards
        colorGroup.removedOnCompletion = false

        colorChart.addAnimation(colorGroup, forKey: "show")

        let greyChartShow = animate(100, duration: 0.5, timingFunction: easeOut)
        greyChartShow.beginTime = colorChartShow.beginTime
        
        let greyChartHide = animate(-1, duration: 0.3, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        greyChartHide.beginTime = colorHide.beginTime
        
        let greyGroup = CAAnimationGroup()
        greyGroup.duration = colorGroup.duration
        greyGroup.fillMode = kCAFillModeForwards
        greyGroup.animations = [greyChartShow, greyChartHide]
        greyGroup.removedOnCompletion = false
        
        greyChart.addAnimation(greyGroup, forKey: "show")
    }
    
    private func animate(percentage: Int, duration: NSTimeInterval, timingFunction: CAMediaTimingFunction) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.repeatCount = 1
        animation.toValue = Double(percentage) / 100.0
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = timingFunction
        
        return animation
    }
    
    func reset() {
        colorChart.removeAllAnimations()
        greyChart.removeAllAnimations()
    }
}
