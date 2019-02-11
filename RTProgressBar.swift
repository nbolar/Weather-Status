//
//  RTProgressBar.swift
//  RTProgressBar
//
//  Created by Daniyar Salakhutdinov on 01.08.16.
//  Copyright © 2016 Daniyar Salakhutdinov. All rights reserved.
//

import Cocoa
import QuartzCore

let kRTProgressBarMaxProgressValue: Double = 100

open class RTProgressBar: NSView {
    
    fileprivate let sublayer = CALayer()
    fileprivate let inlayer = CAGradientLayer()
    fileprivate let lock = NSLock()
    
    fileprivate var progressValue: Double = 0
    
    open var progress: Double { // from 0 to 100
        set(value) {
            setProgress(value, animated: false)
        }
        get {
            return progressValue
        }
    }
    
    open var color: NSColor = NSColor.blue {
        didSet {
            updateColor()
        }
    }
    
    open var animationColor: NSColor? = nil {
        didSet {
            updateColor()
        }
    }
    
    open var backgroundColor: NSColor = NSColor.clear {
        didSet {
            layer?.backgroundColor = backgroundColor.cgColor
        }
    }
    
    open var animating: Bool = false {
        didSet {
            if !indeterminate && animating {
                return
            }
            updateColor()
            if animating {
                inlayer.backgroundColor = nil
                inlayer.locations = [0, 0.001, 0.009, 0.1, 1.1]
                let animation = CABasicAnimation(keyPath: "locations")
                animation.repeatCount = .infinity
                animation.duration = 1.5
                animation.fromValue = inlayer.locations
                animation.toValue = [0, 1, 1.1, 1.11, 1.12]
                inlayer.add(animation, forKey: "locations")
            } else {
                inlayer.removeAllAnimations()
                inlayer.locations = nil
                inlayer.colors = nil
                inlayer.backgroundColor = color.cgColor
            }
        }
    }
    
    open var indeterminate: Bool = false {
        didSet {
            if !indeterminate {
                animating = false
            }
            sublayer.isHidden = indeterminate
            inlayer.isHidden = !indeterminate
        }
    }
    
    // MARK: - view lifecycle
    override open func awakeFromNib() {
        super.awakeFromNib()
        //
        wantsLayer = true
        sublayer.anchorPoint = CGPoint.zero
        layer!.backgroundColor = backgroundColor.cgColor
        layer!.addSublayer(sublayer)
        inlayer.anchorPoint = CGPoint.zero
        inlayer.startPoint = CGPoint(x: 0, y: 0.5)
        inlayer.endPoint = CGPoint(x: 1, y: 0.5)
        inlayer.frame = bounds
        layer!.addSublayer(inlayer)
        inlayer.isHidden = true
        updateColor()
        updateLayerAnimated(false)
    }
    
    override open func layout() {
        super.layout()
        //
        updateLayerAnimated(false)
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        inlayer.frame = bounds
        CATransaction.commit()
    }
    
    // MARK: - progress value setters
    open func append(_ progress: Double, animated: Bool) {
        let value = progressValue + progress
        setProgress(value, animated: animated)
    }
    
    open func setProgress(_ progress: Double, animated: Bool) {
        // set new value
        progressValue = progress > kRTProgressBarMaxProgressValue ? kRTProgressBarMaxProgressValue : progress
        updateLayerAnimated(animated)
    }
    
    // MARK: - inner methods
    fileprivate func updateColor() {
        sublayer.backgroundColor = color.cgColor
        let rightColor = animationColor ?? NSColor.clear
        let inColor = animating ? rightColor : color
        inlayer.colors = [color.cgColor, color.cgColor, inColor.cgColor, color.cgColor, color.cgColor]
    }
    
    fileprivate func updateLayerAnimated(_ animated: Bool) {
        // synchronize
        lock.lock()
        defer {
            lock.unlock()
        }
        // frame
        let size = bounds.size
        let value = progressValue / kRTProgressBarMaxProgressValue
        let layerWidth = CGFloat(Double(size.width) * value)
        if animated {
            // add animation
            let toValue = CGRect(origin: CGPoint.zero, size: CGSize(width: layerWidth, height: size.height))
            let animation = CABasicAnimation(keyPath: "frame")
            animation.duration = 0.3
            animation.fromValue = NSValue(rect: sublayer.frame)
            animation.toValue = NSValue(rect: toValue)
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            sublayer.frame = toValue
            sublayer.add(animation, forKey: "frame")
        } else {
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            sublayer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: layerWidth, height: size.height))
            CATransaction.commit()
        }
    }
}
