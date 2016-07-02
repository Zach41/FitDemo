//
//  Tween.swift
//  FitDemo
//
//  Created by ZachZhang on 16/7/2.
//  Copyright © 2016年 ZachZhang. All rights reserved.
//

import Foundation
import UIKit

class Tween {
    private var layer: TweenLayer!
    
    let object : UIView
    let key : String
    
    var timingFunction: CAMediaTimingFunction {
        get {
            return layer.timingFunction
        }
        set {
            layer.timingFunction = newValue
        }
    }
    
    var mapper: (CGFloat -> AnyObject)?
    
    init(object: UIView, key: String, from: CGFloat, to: CGFloat, duration: NSTimeInterval) {
        self.object = object
        self.key = key
        
        layer = {
            let layer = TweenLayer()
            layer.from = from
            layer.to = to
            layer.tweenDuration = duration
            layer.tweenDelegate = self
            object.layer.addSublayer(layer)
            
            return layer
        }()
    }
    
    convenience init(object: UIView, key: String, to: CGFloat) {
        self.init(object: object, key: key, from: 0, to: to, duration: 0.5)
    }
    
    func start() {
        layer.startAnimaton()
    }
    
    func start(delay delay: NSTimeInterval) {
        layer.delay = delay
        layer.startAnimaton()
    }
    
}

extension Tween : TweenLayerDelegate {
    func tweenLayerDidStopAnimation(layer: TweenLayer) {
        layer.removeFromSuperlayer()
    }
    
    func tweenLayer(layer: TweenLayer, didSetAnimatableProperty to: CGFloat) {
        print("Current Value: \(to)")
        if let mapper = mapper {
            object.setValue(mapper(to), forKey: key)
        } else {
            object.setValue(to, forKey: key)
        }
    }
}

protocol TweenLayerDelegate: class {
    func tweenLayer(layer: TweenLayer, didSetAnimatableProperty to: CGFloat) -> Void
    
    func tweenLayerDidStopAnimation(layer: TweenLayer) -> Void
}


class TweenLayer: CALayer {
    @NSManaged private var animatableProperty : CGFloat
    
    private weak var tweenDelegate: TweenLayerDelegate?
    
    var from: CGFloat = 0
    var to: CGFloat = 0
    var tweenDuration: NSTimeInterval = 0
    var timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    var delay: NSTimeInterval = 0
    
    override class func needsDisplayForKey(event: String) -> Bool {
        return event == "animatableProperty" ? true : super.needsDisplayForKey(event)
    }
    
    override func actionForKey(event: String) -> CAAction? {
        if event != "animatableProperty" {
            return super.actionForKey(event)
        }
        
        let animation = CABasicAnimation(keyPath: event)
        animation.timingFunction = timingFunction
        animation.fromValue = from
        animation.toValue = to
        animation.duration = tweenDuration
        animation.delegate = self
        animation.beginTime = CACurrentMediaTime() + delay
        
        return animation
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        tweenDelegate?.tweenLayerDidStopAnimation(self)
    }
    
    override func display() {
        if let value = presentationLayer()?.animatableProperty {
            tweenDelegate?.tweenLayer(self, didSetAnimatableProperty: value)
        }
    }
    
    func startAnimaton() -> Void {
        animatableProperty = to
    }
    
}