//
//  UITableView+AddOn.swift
//  TFrog
//
//  Created by Alvin on 16/6/12.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit
extension UIViewController {
    
    /*
    open override class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // make sure this isn't a subclass
        //        if self !== UITableView.self {
        //            return
        //        }
        
        dispatch_once(&Static.token) {
            
            
            let originalSelector = #selector(tableView(_:willDisplayCell:forRowAtIndexPath:))
            let swizzledSelector = #selector(av_tableView(_:willDisplayCell:forRowAtIndexPath:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
    

    //MARK: - protocol implementations
    dynamic public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    dynamic public func av_tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        LogManager.shared.log("监听 willDisplayCell")
        
        if self.respondsToSelector(#selector(self.av_tableView(_:willDisplayCell:forRowAtIndexPath:))) {
            self.av_tableView(tableView: tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
        }else{
            self.setSeparatorInsetWithTarget(target: cell, insets: UIEdgeInsetsMake(0, 0, 0, 0))
        }

        //        // 下面这几行代码是用来设置cell的上下行线的位置
        //
//        if #available(iOS 8.0, *) {
//            
//            cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
//        } else {
//            // Fallback on earlier versions
//        }
//        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
//        
//        if #available(iOS 8.0, *) {
//            //cell.preservesSuperviewLayoutMargins = false
//        } else {
//            // Fallback on earlier versions
//        }
        
        
        
    }
    
    func setSeparatorInsetWithTarget(target: UITableViewCell, insets: UIEdgeInsets) {
        if target.respondsToSelector(Selector("setSeparatorInset:")) {
            target.separatorInset = insets
        }
        if target.respondsToSelector(Selector("setLayoutMargins:")) {
            if #available(iOS 8.0, *) {
                target.layoutMargins = insets
            } else {
                // Fallback on earlier versions
            }
        }
    }
    */
}
