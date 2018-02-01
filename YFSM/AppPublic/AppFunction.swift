//
//  AppFunction.swift
//  HangJia
//
//  Created by Alvin on 16/1/7.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import Foundation

/**
 APP环境
 
 - EnvironmentNone:     未知版本
 - EnvironmentAppStore: AppStore版本
 - EnvironmentTest:     测试版本
 - EnvironmentDis:      生产环境
 */
enum EnvironmentType {
    /// 未知版本
    case environmentNone
    /// AppStore版本
    case environmentAppStore
    /// 测试版本
    case environmentTest
    /// 生产环境
    case environmentDis
}

class AppFunction {
    
    /**
     获取APP环境
     
     - returns: 0:未知 1:AppStore环境 2:测试环境 3:分发生产环境
     */
    class func environmentIndex() -> EnvironmentType {
        
        var environmentIndex: EnvironmentType = .environmentNone
        let bundleIDStr = Bundle.main.bundleIdentifier!
        
        switch bundleIDStr {
        case "yao.NCVTNews"://com.yds.ncvt.DigitalCampus
            environmentIndex = .environmentAppStore
            LogManager.shared.isDebug = false
        case "com.yds.newsapp.dis":
            environmentIndex = .environmentDis
        default: environmentIndex = .environmentDis//com.yds.newsapp.pre
        }
        
        return environmentIndex
    }
}

