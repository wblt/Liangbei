//
//  UIColor+AddOn.swift
//  demo-swift
//
//  Created by Alvin on 16/4/9.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit

extension UIColor {

	/**
	 创建纯色图片

	 - returns: 纯色图片
	 */
	func createImageWithColor() -> UIImage {

		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()!
		context.setFillColor(self.cgColor)
		context.fill(rect)
		let theImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return theImage!
	}

	/**
	 创建纯色图片

	 - parameter color: 颜色

	 - returns: 纯色图片
	 */
	class func createImageWithColor(_ color: UIColor) -> UIImage {

		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()!
		context.setFillColor(color.cgColor)
		context.fill(rect)
		let theImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return theImage!
	}

	/**
	 RGBHex转UIColor

	 - parameter hex: RGBHex 例如：0xFFFFFF

	 - returns: UIColor
	 */
	class func colorWithRGBHex(_ hex: UInt32) -> UIColor {

		let r: UInt32 = (hex >> 16) & 0xFF
		let g: UInt32 = (hex >> 8) & 0xFF
		let b: UInt32 = 0xFF // as! hex)

		return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
	}

	/**
	 RGBHex转UIColor 支持0x和#开头的格式,标识颜色

	 - parameter hexStr: RGBHex 例如：0xFFFFFF, #FFFFFF

	 - returns: UIColor
	 */
	class func colorWithHexString(_ hexStr: String) -> UIColor {

		let egba = hexStrToRGBA(hexStr)
		if let egba = egba {
			return egba
		}
		return UIColor()
	}

	/**
	 透明度

	 - returns: 透明度
	 */
	func alpha() -> CGFloat {

		return self.cgColor.alpha
	}

	/**
	 十六进制转CGFloat

	 - parameter str: 十六进制

	 - returns: CGFloat
	 */
	class func hexStrToInt(_ str: String) -> CGFloat {

		var result: UInt32 = 0
		_ = (Scanner.localizedScanner(with: str) as AnyObject).scanHexInt32(&result)

		return CGFloat(result)
	}

	/**
	 支持0x和#开头的格式,根据3位4位6位8位标识识别颜色

	 - parameter str: RGBHex

	 - returns: UIColor?
	 */
	class func hexStrToRGBA(_ RGBHex: String) -> UIColor? {

        var str = RGBHex
		str = str.stringByTrim().uppercased()

		if str.hasPrefix("#") {
			str = (str as NSString).substring(from: 1)
		} else if str.hasPrefix("0X") {
			str = (str as NSString).substring(from: 2)
		}

		let length: Int = str.characters.count
		// RGB            RGBA          RRGGBB        RRGGBBAA
		if length != 3 && length != 4 && length != 6 && length != 8 {
			return nil
		}
		// RGB,RGBA,RRGGBB,RRGGBBAA
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0 , a:CGFloat = 0

		var retColor: UIColor!
		if length < 5 {

			r = hexStrToInt((str as NSString).substring(with: NSMakeRange(0, 1))) / 255.0
			g = hexStrToInt((str as NSString).substring(with: NSMakeRange(1, 1))) / 255.0
			b = hexStrToInt((str as NSString).substring(with: NSMakeRange(2, 1))) / 255.0

			if length == 4 {
				a = hexStrToInt((str as NSString).substring(with: NSMakeRange(3, 1))) / 255.0
			}
			else {
				a = 1
			}
			retColor = UIColor(red: r, green: g, blue: b, alpha: a)
		} else {

			r = hexStrToInt((str as NSString).substring(with: NSMakeRange(0, 2))) / 255.0
			g = hexStrToInt((str as NSString).substring(with: NSMakeRange(2, 2))) / 255.0
			b = hexStrToInt((str as NSString).substring(with: NSMakeRange(4, 2))) / 255.0

			if length == 8 {
				a = hexStrToInt((str as NSString).substring(with: NSMakeRange(6, 2))) / 255.0
			} else {
				a = 1
			}
			retColor = UIColor(red: r, green: g, blue: b, alpha: a)
		}
		return retColor
	}
}

