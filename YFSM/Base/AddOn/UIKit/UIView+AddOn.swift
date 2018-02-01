//
//  UIView+AddOn.swift
//  HangJia
//
//  Created by Alvin on 16/1/7.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit

/// Association key
private var cornerRadiiFloatKey: UInt = 0
//var cornerRadiiFloatKey

extension UIView {
    
    /**
     设置圆角
     
     - parameter cornerRadii: <#cornerRadii description#>
     */
    func setCornerLayerWithCornerRadii(_ cornerRadii: CGFloat) {
        cornerRadiiFloatKey = UInt(cornerRadii)
        
        let cornerPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = self.bounds
        cornerLayer.path = cornerPath.cgPath
        self.layer.mask = cornerLayer
    }
    
    func setCornerRadiiFloat(_ cornerRadiiFloat: String) {
        objc_setAssociatedObject(self, &cornerRadiiFloatKey, cornerRadiiFloat, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // 设置真实值
    func setAbsX(_ x: CGFloat) {
        var frame: CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    
    func setAbsY(_ y: CGFloat) {
        var frame: CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    
    func addAbsX(_ x: CGFloat) {
        var frame: CGRect = self.frame
        frame.origin.x += x
        self.frame = frame
    }
    
    func addAbsY(_ y: CGFloat) {
        var frame: CGRect = self.frame
        frame.origin.y += y
        self.frame = frame
    }
    
    /**
     设置圆角边框
     
     - parameter cornerRadius: 圆角
     - parameter width:        边框宽度
     - parameter color:        边框颜色
     */
    func setCornerBorderWithCornerRadii(_ cornerRadius: CGFloat, width: CGFloat, color: UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
}

extension UIView {
    
    class func loadFromNib() -> AnyObject {
        
        return loadFromNibNamed("\(self.classForCoder())")
    }
    
    class func loadFromNibNamed(_ nibName: String) -> AnyObject {
        var nibObjects: [AnyObject] = Bundle.main.loadNibNamed(nibName, owner: self, options: nil) as! [AnyObject]
        
        return nibObjects[0]
    }
}


extension UIView {
    
    @IBInspectable var tCornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
            self.layer.shouldRasterize = true// 当shouldRasterize设成true时，layer被渲染成一个bitmap，并缓存起来，等下次使用时不会再重新去渲染了
            self.layer.rasterizationScale = UIScreen.main.scale// 由于rasterizationScale默认等于1.0，会使得高清屏幕下图片像素化，所以我们还要同时设置一下rasterizationScale
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var tBorderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var tBorderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
}
