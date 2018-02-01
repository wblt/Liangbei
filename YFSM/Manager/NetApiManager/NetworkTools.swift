//
//  NetworkTools.swift
//  YFSM
//
//  Created by 何建波 on 2018/1/15.
//  Copyright © 2018年 wb. All rights reserved.
//

import UIKit
import AFNetworking
// 定义枚举类型
enum HTTPRequestType : Int{
    case GET = 0
    case POST
}

class NetworkTools: AFHTTPSessionManager {
    // 设计单例 let是线程安全的
    static let shareInstance : NetworkTools = {
        let tools = NetworkTools()
//        tools.responseSerializer = AFHTTPResponseSerializer();
//        tools.requestSerializer = AFHTTPRequestSerializer();
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
    
}

// 封装请求方法
extension NetworkTools {
    func request(methodType : HTTPRequestType, urlString : String, parameters : [String : AnyObject], finished :@escaping (_ result : AnyObject?, _ error : Error?)-> ())  {
        // 1 成功回调
        let successCallBack = {(task :URLSessionDataTask, result : Any) in
            finished(result as AnyObject?, nil)
        }
        // 2 失败回调
        let failureCallBack = {(task : URLSessionDataTask?, error :Error) in
            finished(nil, error)
        }
        
        if methodType == .GET {
            // get请求
            
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }else {
            // post请求
            
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            
        }
    }
}

