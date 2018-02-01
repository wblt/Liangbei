//
//  AccountManager.swift
//  TFrog
//
//  Created by Alvin on 16/6/1.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit
import SDWebImage
import YYCache

class AccountManager {
    
    static let shared = AccountManager()
    fileprivate var cache: YYCache!
    fileprivate let cacheKey = " StudentModel"
    var isFirstLogin: Bool! {
        set(newValue) {
            UserDefaults.standard.set(!newValue, forKey: "isFirstLogin")
        }
        get {
            return !UserDefaults.standard.bool(forKey: "isFirstLogin")
        }
    }
    
    fileprivate init() {
        
        cache = YYCache(name: "AccountManager")
        cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = true
        cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = true
    }
    
    var account: StudentModel? {
        get {
            return getAccount()
        }
    }
    
    /// 用户登录
    ///
    /// - Parameters:
    ///   - account: JSON数据
    ///   - firstLogin: true: 登录接口登录的
    func login(_ account: [String : Any], firstLogin: Bool = false) {
        cache.setObject(account as NSCoding?, forKey:  cacheKey)
        let userid = "\(String(describing: account["userid"]))"
        if !userid.isEmpty {
            LogManager.shared.log("登录成功 ---- token = \(userid)")
            UDManager.shared.saveUserToken(userid)
        }
        
        
    }
    
    /// 去登录
    func gotoLogin() {
        
        if !(UIApplication.sharedDelegate().window?.rootViewController is LoginNavC) {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: cNShouldLogin), object: nil)
        }
    }
    
    /// 获取用户缓存
    ///
    /// - Returns: StudentModel
    fileprivate func getAccount() -> StudentModel? {
        
        if let cache = cache.object(forKey:  cacheKey) as? [String : Any] {
            
            let model = Reflect<StudentModel>.mapObject(json: cache as AnyObject?)
            return model
        }
        
        return nil
    }
    
    /// 退出登录
    ///
    /// - Parameter callBack: 退出登录后
    func logoutAccount(callBack: (()->Void)?) {
        
        removeCookie()
        cache.removeObject(forKey:  cacheKey) { (key) in
            
            if UDManager.shared.removeUserToken() {
                
            //    ClassTableManager.shared.delete()
              //  ScoreManager.shared.delete()
                //BFunction.shared.isShowYaoYiYao = true//退出登录，可以再次弹窗摇一摇
                
                //ContactManager.shared.removeAll()
              //  RCIMClient.shared().logout()//退出融云，接收远程推送
                NotificationCenter.default.post(name: Notification.Name(rawValue: cNTabbarBadgeValue), object: 0)
                
                callBack?()
            }
        }
    }
    
    /// 清除Cookie
    fileprivate func removeCookie() {
        let array = HTTPCookieStorage.shared.cookies
        
        if let array = array {
            for cookie in array {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    /// 是否已登录
    ///
    /// - Parameter isShowTip: 是否通知登陆
    /// - Returns: true: 已登录
    func isLogin(isShowTip: Bool) -> Bool {
        
        let isLogin = self.isLogin()
        
        if !isLogin {
            if isShowTip {
                NotificationCenter.default.post(name: Notification.Name(rawValue: cNShouldLogin), object: nil)
            }
        }
        return isLogin
    }
    
    /// 是否已登录
    ///
    /// - Returns: true: 已登录
    func isLogin() -> Bool {
        
        let isLogin = !(UDManager.shared.userToken().length == 0 )
        
        return isLogin
    }
}
