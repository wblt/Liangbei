//
//  Utility.swift
//  HangJia
//
//  Created by Alvin on 16/1/28.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import SDWebImage

class Utility {
    
    
    

    //返回裁剪区域图片,返回裁剪区域大小图片
    
    class func clipImage(with image: UIImage, in rect: CGRect) -> UIImage {
        
        let imageRef: CGImage? = image.cgImage?.cropping(to: rect)
        
        if imageRef == nil {
            return UIImage()
        }
        
        UIGraphicsBeginImageContext(image.size)
        let context: CGContext? = UIGraphicsGetCurrentContext()
    
        context?.draw(imageRef!, in: rect)
        //context.draw(imageRef, image: rect)
        let clipImage = UIImage(cgImage: imageRef!)

        UIGraphicsEndImageContext()

        return clipImage
    }

    
    
    /// 延迟执行
    ///
    /// - parameter delay:   延迟时间
    /// - parameter closure: 延迟执行代码
    class func delay(_ delay:Double, closure: @escaping ()->Void) {
        
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    /**
     生成随机字符串
     
     - parameter len: 随机字符串的长度
     
     - returns: 随机字符串
     */
    class func randomStringWithLength(_ len: Int) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        // let letters: NSString = "abcdefghijklmnopqrstuvwxyz0123456789"
        
        let muStr: NSMutableString = NSMutableString(capacity: len)
        for _ in 0 ..< len {
            let index = arc4random_uniform(UInt32(letters.length))
            muStr.appendFormat("%c", letters.character(at: Int(index)))
        }
        return muStr as String
    }
    
    /**
     字典按key排序，并拼接成字符串
     
     - parameter dic: <#dic description#>
     
     - returns: <#return value description#>
     */
    class func sort(with dic: [String: Any]) -> String {
        var newDic = dic
        
        if let time = dic["timeJob"] as? Int {
            newDic["timeJob"] = time + 10000
        }
        
        let arr = newDic.sorted(by: { $0.0 < $1.0 })
        
        var str = ""
        for (key, value) in arr {
            str += "\(key)=\(value)&"
        }
        
        LogManager.shared.log("字典按key排序之后: \(str) \n")
        
        let token = UDManager.shared.userToken()
        let signStr = str + "token=\(token)"
        LogManager.shared.log("要加密的Str: \(signStr) \n")
        
        return signStr
    }
    
    /**
     根据时间戳格式化时间
     
     - parameter oldTime: 时间戳
     
     - returns: 时间字符串
     */
    class func nowFromDateExchange(_ oldTime: Double) -> String {
        let oldTimeDate = Date(timeIntervalSince1970: oldTime)
        let format = oldTimeDate.isThisYear ? "MM-dd" : "yyyy-MM-dd"
        
        return nowFromDateExchange(oldTime, format: format)
    }
    
    /**
     根据时间戳格式化时间
     
     - parameter oldTime: 时间戳
     - parameter format:  超过一个月显示的时间格式
     
     - returns: 时间字符串
     */
    class func nowFromDateExchange(_ oldTime: Double, format: String) -> String {
        
        // 计算现在距1970年多少秒
        if let currentTime = UDManager.shared.serverTime() {
            
            // 计算现在的时间和发布消息的时间时间差
            var timeDiffence = (currentTime / 1000) - oldTime
            
            // 根据秒数的时间差的不同，返回不同的日期格式
            
            if timeDiffence <= 60 {
                
                if timeDiffence == 0.0 {
                    timeDiffence += 1
                }
                
                return "\(Int(timeDiffence))秒前"
                
            } else if timeDiffence <= 3600 {
                return "\(Int(timeDiffence / 60))分钟前"
            } else if timeDiffence <= 86400 {
                return "\(Int(timeDiffence / 3600))小时前"
            } else if timeDiffence <= 604800 {
                return "\(Int(timeDiffence / 3600 / 24))天前"
            } else {
                let oldTimeDate = Date(timeIntervalSince1970: oldTime)
                let formatter = DateFormatter()
                formatter.dateFormat = format
                return formatter.string(from: oldTimeDate)
            }
        }
        
        return ""
    }
    
    /**
     获取缓存图片
     
     - parameter url:      图片路径
     - parameter index:    下标，防止网络异步回调位置错乱
     - parameter callBack: callBack
     */
    class func getCacheImageWithURL(_ url: String, index: Int, callBack: @escaping ((_ index: Int, _ image: UIImage?) -> Void)) {
        let url = URL(string: url)
        guard let URL = url else { callBack(0, nil); return }
        
        
        SDWebImageManager.shared().diskImageExists(for: URL) { (isInCache) in
            
            if isInCache {
                
                LogManager.shared.log("本地有缓存")
                
                let image: UIImage? = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: URL.absoluteString)
                
                if image != nil {
                    LogManager.shared.log("读取本地缓存")
                    
                    if image!.size.height == image!.size.width {
                        callBack(index, image)
                    } else {
                        callBack(index, image)
                    }
                }
            } else {
                
                LogManager.shared.log("本地没有缓存，正在下载。。。")
                
                _ = SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL, options: SDWebImageDownloaderOptions.allowInvalidSSLCertificates, progress: nil, completed: { (image, data, error, finished) in
                    
                    if finished && (image != nil) {
                        
                        if image!.size.height == image!.size.width {
                            callBack(index, image)
                        } else {
                            callBack(index, image)
                        }
                    }
                })
            }
        }
    }
}
