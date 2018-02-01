//
//  String+AddOn.swift
//  HangJia
//
//  Created by Alvin on 16/1/26.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import Foundation
import UIKit


func + <T>(left: T, right: String) -> String {
    
    return "\(left)" + right
}
func + <T>(left: String, right: T) -> String {
    
    return left + "\(right)"
}

extension String {
    
    var double: Double? { return Double(self) }
    var float: Float? { return Float(self) }
    var int: Int? { return Int(self) }
    var length: Int { return self.characters.count }
}

extension String {
    
    /**
     去除空格
     
     - returns: newString
     */
    func stringByTrim() -> String {
        let set: CharacterSet = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: set)
    }
    
    /**
     字符串转换为format格式的时间
     
     - parameter format: 时间格式 例如: yyyy-MM-dd
     
     - returns: NSDate
     */
    func dateWithFormat(_ format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+0800")
        formatter.dateFormat = format
        let date: Date = formatter.date(from: self)!
        return date
    }
    
    /**
     判断纯数字组合
     
     - returns: true: 是 false: 不是
     */
    func isAllDigit() -> Bool {
        let regexString: String = "^[0-9]+$"
        let pred = NSPredicate(format: "self MATCHES %@", regexString)
        let isMatch = pred.evaluate(with: self)
        
        return isMatch
    }
    
    /**
     判断手机号码
     
     - returns: true: 是 false: 不是
     */
    func isCellPhone() -> Bool {
        let regexString: String = "^1[3|4|5|7|8][0-9]\\d{8}$"
        let pred = NSPredicate(format: "self MATCHES %@", regexString)
        let isMatch = pred.evaluate(with: self)
        
        return isMatch
    }
    
    /// 字符串转NSURL
    var url: URL? {
        let url = URL(string: self)
        guard let u = url else { return nil }
        return u
    }
    
    /// http，https，ftp正则判断
    var isWeb: Bool {
        let regex = "^(([hH][tT]{2}[pP][sS]?)|([fF][tT][pP]))\\:\\/\\/[wW]{3}\\.[\\w-]+\\.\\w{2,4}(\\/.*)?$"
        let pred = NSPredicate(format: "self MATCHES %@", regex)
        let isMatch = pred.evaluate(with: self)
        
        return isMatch
    }
    
    /// 字符串截取
    func substringToIndex(_ index: Int) -> String? {
        guard index > 0 else {
            return nil
        }
        if index >= self.characters.count {
            return self
        }
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: index))
    }
    /// 字符串截取
    func substringFromIndex(_ index: Int) -> String? {
        guard index > 0 else {
            return nil
        }
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: index))
    }
    
    /// 字符串截取
    func substringWithRange(_ range: Range<Int>) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.characters.index(self.startIndex, offsetBy: range.upperBound)
        
        return self.substring(with: start..<end)
    }
    
    /**
     截取区间子字符串
     
     - parameter startIndex: 起始位置
     - parameter endIndex:   结束位置
     
     - returns: subString
     */
    func substringWithRange(_ startIndex: Int, endIndex: Int) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        let end = self.characters.index(self.startIndex, offsetBy: endIndex)
        
        return self.substring(with: start..<end)
    }
    
    /**
     删除字符串
     
     - parameter character: 要删除的字符串
     
     - returns: newString
     */
    func deleteCharacter(_ character: String) -> String {
        return self.replacingOccurrences(of: character, with: "")
    }
    
    /// 字符串去空格
    var deleteSpace: String {
        let newStr = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) // 只能去掉前后空格
        
        return newStr.deleteCharacter(" ")
    }
    
    /**
     计算字符串Size
     
     - parameter fontSize: 字体大小
     - parameter width:    字符串显示的宽度
     
     - returns: CGSize
     */
    func adjustSizeAtWidth(_ fontSize: CGFloat, width: CGFloat) -> CGSize {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle.copy()]
        let rect = self.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size
    }
    
    /**
     计算字符串Height
     
     - parameter fontSize: 字体大小
     - parameter width:    字符串显示的宽度
     
     - returns: 字符串高度
     */
    func adjustHeightAtWidth(_ fontSize: CGFloat, width: CGFloat) -> CGFloat {
        
        return adjustSizeAtWidth(fontSize, width: width).height
    }
    
    /**
     计算字符串Width
     
     - parameter fontSize: 字体大小
     - parameter height:   字符串显示的高度
     
     - returns: 字符串宽度
     */
    func adjustWidthAtHeight(_ fontSize: CGFloat, height: CGFloat) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle.copy()]
        let rect = self.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.width
    }
    
}

extension String {
    
    /// 获取颜色 #FFFFFF
    var colorWithHexString: UIColor {
        let rgb = hexStrToRGBA(self)
        return UIColor(red: rgb.0 / 255.0, green: rgb.1 / 255.0, blue: rgb.2 / 255.0, alpha: 1.0)
    }
    
    /**
     获取十六进制颜色RGB
     
     - parameter hexColorString: "#FFFFFF",0xFFFFFF
     
     - returns: (r,g,b)
     */
    fileprivate func hexStrToRGBA(_ hexColorString: String) -> (CGFloat, CGFloat, CGFloat) {
        
        guard hexColorString.characters.count > 5 else {
            return (0, 0, 0)
        }
        
        guard hexColorString.hasPrefix("0x") || hexColorString.hasPrefix("#") else {
            
            if hexColorString.characters.count == 6 {
                // r
                let rString = hexColorString.substringWithRange(Range(0 ..< 2))
                
                // g
                let gString = hexColorString.substringWithRange(Range(2 ..< 4))
                
                // b
                let bString = hexColorString.substringWithRange(Range(4 ..< 6))
                
                var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
                
                Scanner(string: rString).scanHexInt32(&red)
                Scanner(string: gString).scanHexInt32(&green)
                Scanner(string: bString).scanHexInt32(&blue)
                
                return (CGFloat(red), CGFloat(green), CGFloat(blue))
            }
            
            return (0, 0, 0)
        }
        var cString: String!
        
        if hexColorString.hasPrefix("0x") {
            cString = hexColorString.substringFromIndex(2)
        } else if hexColorString.hasPrefix("#") {
            cString = hexColorString.substringFromIndex(1)
        }
        
        guard cString.characters.count == 6 else {
            return (0, 0, 0)
        }
        
        // r
        let rString = cString.substringWithRange(Range(0 ..< 2))
        
        // g
        let gString = cString.substringWithRange(Range(2 ..< 4))
        
        // b
        let bString = cString.substringWithRange(Range(4 ..< 6))
        
        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        
        Scanner(string: rString).scanHexInt32(&red)
        Scanner(string: gString).scanHexInt32(&green)
        Scanner(string: bString).scanHexInt32(&blue)
        
        return (CGFloat(red), CGFloat(green), CGFloat(blue))
    }
}

extension String {
    
    func mattress_MD5() -> String? {
        let cString = self.cString(using: String.Encoding.utf8)
        let length = CUnsignedInt(
            self.lengthOfBytes(using: String.Encoding.utf8)
        )
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(cString!, length, result)
        
        return String(format:
            "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]).uppercased()
    }
}

extension String {
   
    func toData() -> Data? {
        
        let data = self.data(using: String.Encoding.utf8)
        
        return data
    }
}
