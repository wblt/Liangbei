//
//  NavigationManger.swift
//  HangJia
//
//  Created by Alvin on 16/2/20.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit

class NavigationManager: NSObject {
    
    /// 登录页面
   /* class func pushToLoginVC(form vc: UIViewController) {
        
        let loginVC = StoryboardManager.storyboard(with: "Login")("LoginNavC") as! LoginNavC
        
        vc.present(loginVC, animated: true, completion: nil)
    }
    */
    /// WebView
    ///
    /// - Parameters:
    ///   - vc: <#vc description#>
    ///   - url: 链接地址
    ///   - title: 标题 默认是“”，获取网页标题
    class func pushToWebView(form vc: UIViewController, url: String, title: String = "") {
        
        let webView = BaseWebView()
        webView.loadUrlString(url, title: title)
        
        vc.navigationController?.pushViewController(webView, animated: true)
    }

    /// WebView
    ///
    /// - Parameters:
    ///   - vc: <#vc description#>
    ///   - fileName: 文件名
    ///   - title: 标题 默认是“”，获取网页标题
    class func pushToNativeWebView(form vc: UIViewController, fileName: String, title: String = "") {
        
        let webView = BaseWebView()
      //  webView.loadUrlString(url, title: title)
        webView.loadFileName(fileName, title: title)
        vc.navigationController?.pushViewController(webView, animated: true)
    }
    
    
 }
