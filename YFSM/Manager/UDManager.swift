//
//  UDManager.swift
//  HangJia
//
//  Created by Alvin on 16/1/7.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import Foundation
import UIKit
class UDManager {
    
    static let shared = UDManager()
    fileprivate let cSandboxAppVersion = "cSandboxAppVersion"
    fileprivate let cSystemUUID = "cSystemUUID"
    fileprivate let cPushToken = "cPushToken"
    fileprivate let cServerTime = "cServerTime"
    fileprivate let cUserToken = "cUserToken"
    fileprivate let userDefaults = UserDefaults.standard
    
    fileprivate init() {
    
    }
    
    /**
     保存设备Token
     
     - parameter deviceToken: 设备Token
     
     - returns: true:保存成功 false:保存失败
     */
    func savePushToken(_ deviceToken: Data) -> Bool {
       
        let token: NSMutableString = NSMutableString(format: "%@", deviceToken as CVarArg)
        token.replaceOccurrences(of: " ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, token.length))
        token.replaceOccurrences(of: "<", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, token.length))
        token.replaceOccurrences(of: ">", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, token.length))
        
        userDefaults.set(token, forKey: cPushToken)
        
        return userDefaults.synchronize()
    }
    
    /**
     保存设备Token
     
     - parameter deviceToken: 设备Token
     
     - returns: true:保存成功 false:保存失败
     */
    func savePushToken(_ deviceToken: String, ss:String = "") -> Bool {
        
        userDefaults.set(deviceToken, forKey: cPushToken)
        
        return userDefaults.synchronize()
    }
    
    /**
     设备token
     
     - returns: 设备token
     */
    func pushToken() -> String {
       
        if let token = userDefaults.object(forKey: cPushToken) as? String {
            
            return token
        }else{
            
            return ""
        }
    }
    
    /**
     设备UUID
     
     - returns: 设备UUID
     */
    func uuid() -> String? {
       
        if let uuid = userDefaults.object(forKey: cSystemUUID) as? String {
            
            return uuid
        }else{
            
            let uuid = UIDevice.current.uuid
            userDefaults.set(uuid, forKey: cSystemUUID)
            userDefaults.synchronize()
            
            return uuid
        }
    }
    
    /**
     保存用户Token
     
     - parameter token: 用户Token
     */
    func saveUserToken(_ token: String) {
        
        userDefaults.set(token, forKey: cUserToken)
    }
    
    /**
     删除用户Token
     */
    func removeUserToken() -> Bool {
        
        userDefaults.removeObject(forKey: cUserToken)
        NotificationCenter.default.post(name: Notification.Name(rawValue: cNDidLogout), object: nil)
        
        return userDefaults.synchronize()
    }
    
    /**
     读取用户Token
     
     - returns: 用户Token
     */
    func userToken() -> String {
        
        
        
        if let accessToken = userDefaults.object(forKey: cUserToken) as? String, !accessToken.isEmpty {
            
            return accessToken
        }else{
            
            return ""
        }
    }
    
    /**
     保存服务器时间
     
     - parameter time: 服务器时间
     */
    func saveServerTime(_ time: TimeInterval) {
        
        let currentTime = Date.currentTimestamp()
        LogManager.shared.log("与服务器时间差＝＝＝＝\(time - currentTime)")
        
        userDefaults.set(time - currentTime, forKey: cServerTime)
    }
    
    /**
     读取服务器时间
     
     - returns: 服务器时间
     */
    func serverTime() -> TimeInterval? {
        
        if let serverTime = userDefaults.object(forKey: cServerTime) as? TimeInterval {
            
            let currentTime = Date.currentTimestamp()
            return currentTime + serverTime
        }
        
        return nil
    }
    
    /**
     保存版本信息
     
     - returns: true:保存成功 false:保存失败
     */
    func saveVersion() -> Bool {
        
        let curVer = UIApplication.shared.appVersion()
        userDefaults.set(curVer, forKey: cSandboxAppVersion)
        
        return userDefaults.synchronize()
    }
    
    /**
     是否新版本
     
     - returns: true:是新版本 false:不是新版本
     */
    func isNewVersion() -> Bool {
        
        let oldVersion = userDefaults.object(forKey: cSandboxAppVersion) as? String
        let currentVersion = UIApplication.shared.appVersion()
        
        var isNewVersion = false
        
        if oldVersion == nil {//新版本
            isNewVersion = true
        }
        
        if oldVersion == currentVersion {// 版本一样
            
            isNewVersion = false
        }else{// 新版本
            
            isNewVersion = true
        }
        
        //保存相关记录
        if isNewVersion {
            
            _ = saveVersion()
        }
        
        return isNewVersion
    }
}
