//
//  DeviceManager.swift
//  HangJia
//
//  Created by Alvin on 16/2/15.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit
import SDWebImage

class DeviceManager {

    static let shared = DeviceManager()
    
    fileprivate init() {
        
        SDWebImageManager.shared().imageCache?.maxMemoryCost = UInt(200 * 1024 * 1024)//设置图片磁盘缓存大小 200M
    }
    
    func openCall(phone: String) {
        
        UIApplication.shared.openURL(URL(string: "tel://\(phone)")!)
    }
    
	/**
     总磁盘容量
     
     - returns: 图片缓存大小
     */
	func totalDiskCacheSize() -> Float {

        let size = SDImageCache.shared().getSize()
		let mb = Float(size) / 1024 / 1024

		return Float(String(format: "%.2f", Float(mb)))!
	}

	/**
     清空缓存
     */
    func clearSDImageCache(completionBlock: (() -> Void)?) {
        
        BFunction.shared.showLoading()
        
        SDImageCache.shared().clearDisk { 
            
            BFunction.shared.hideLoadingMessage()
            
            BFunction.shared.showAlert(title: "提示", subTitle: "成功清空缓存!", cancelBtnTitle: "确定", cancelBtnAction: {
                
                completionBlock?()
            })
        }
	}
}
