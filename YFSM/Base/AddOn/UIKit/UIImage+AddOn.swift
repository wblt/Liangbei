//
//  UIImage+AddOn.swift
//  HangJia
//
//  Created by Alvin on 16/1/14.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     生成纯色图片
     
     - parameter color: 颜色
     
     - returns: newUIImage
     */
    class func imageWithColor(_ color: UIColor) -> UIImage {
        // 描述矩形
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        // 获取位图上下文
        let context = UIGraphicsGetCurrentContext()!
        // 使用color演示填充上下文
        context.setFillColor(color.cgColor)
        // 渲染上下文
        context.fill(rect)
        // 从上下文中获取图片
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        // 结束上下文
        UIGraphicsEndImageContext()
        return theImage!
    }
    
    /**
     图片压缩
     
     - parameter targetSize:  压缩到指定大小
     
     - returns: newUIImage
     */
    func imageByScalingAndCroppingForSize(_ targetSize: CGSize) -> UIImage {
        let sourceImage: UIImage = self
        var newImage: UIImage? = nil
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        if imageSize.equalTo(targetSize) == false {
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            }
            else {
                scaleFactor = heightFactor
            }
            // scale to fit width
            scaledWidth = width * scaleFactor
            
            scaledHeight = height * scaleFactor
            // center the image
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }
            else if widthFactor < heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        // this will crop
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        if newImage == nil {
            NSLog("could not scale image")
        }
        // pop the context to get back to the default
        UIGraphicsEndImageContext()
        return newImage!
        
    }
}


extension UIImage {
    
    func compressImage(with maxLength: Int) -> Data {
        
        var compress:CGFloat = 0.9
        var data = UIImageJPEGRepresentation(self, compress)
        
        while (data!.count) > maxLength && compress > 0.01 {
            
            compress -= 0.02
            data = UIImageJPEGRepresentation(self, compress)
            print("data2 === \(data!.count)")
        }
        
        return data!
    }
}
