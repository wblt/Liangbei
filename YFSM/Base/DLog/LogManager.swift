//
//  DLog.swift
//  HangJia
//
//  Created by Alvin on 16/1/7.
//  Copyright © 2016年 Alvin. All rights reserved.
//



class LogManager {
    
    static let shared = LogManager()
    var isDebug = true
    
    fileprivate init() {
    
    }
    
    func log(_ code: Int?, msg: Any) {
        
        if isDebug {
            
            print("调试日志输出 ===>> 错误码: \(code)\t描述: \(msg) \n")
        }
    }
    
    func log(_ msg: Any) {
        
        log(nil, msg: msg)
    }
}
