//
//  BaseRequest.swift
//  HangJia
//
//  Created by Alvin on 16/2/29.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit
import AFNetworking


/// 请求成功回调
typealias RequestSucceed    = (_ response: URLResponse?, _ responseObject: Any?, _ hasMore: Bool) -> ()
/// 请求错误回调
typealias RequestError      = (_ response: URLResponse?, _ errorObject: ErrorModel) -> ()
/// 请求失败回调
typealias RequestFailure    = (_ response: URLResponse?, _ error: Error) -> ()
/// 空数据回调
typealias RequestEmptyData  = () -> ()

class BaseRequest {
    
    static let shared = BaseRequest()
    var isNetWorkUsable = false //网络是否可用
    var netPageSize = 20 //每次请求数据长度
    
    fileprivate init() {
        
        // 监听网络状态
        reachabilityManager.setReachabilityStatusChange { (status: AFNetworkReachabilityStatus) in
            
            switch status {
            case .notReachable, .unknown:
                
                self.isNetWorkUsable = false
                BFunction.shared.showErrorMessage(tipNetError)
            default:
                
                self.isNetWorkUsable = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: cNNetSuccess), object: nil)
            }
        }
        reachabilityManager.startMonitoring()
    }
    
    /// 服务器地址
    lazy var apiURL: String = {
        
        switch AppFunction.environmentIndex() {
            
        case .environmentTest:
            
            return cTestDomainUrl// 测试环境
        default :
            
            return cProductionDomainUrl// 生产环境
        }
    }()
    
    lazy var serializer: AFHTTPRequestSerializer = {
        let request = AFHTTPRequestSerializer()
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("abc", forHTTPHeaderField: "noTest")
        request.setValue(UIApplication.shared.appVersion(), forHTTPHeaderField: "version")
        request.setValue("iOS", forHTTPHeaderField: "device")
        
        return request
    }()
    
    lazy var sessionManager: AFURLSessionManager = {
        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        return manager
    }()
    
    lazy var reachabilityManager: AFNetworkReachabilityManager = {
        let manager = AFNetworkReachabilityManager.shared()
        return manager
    }()
    
}

extension BaseRequest {
    
    /**
     停止所有请求
     */
    func stopAllAfRequestMgrRequest() {
        
        Utility.delay(0.45) {
            
            _ = self.sessionManager.tasks.dropLast().map({ $0.cancel() })
        }
    }
    
    /// 解析数据
    func getObject<T: NSObject> (with json: Any?, object: T) -> (T?, [T]?) {
        
        guard json is [String:Any] || json is [[String:Any]] else {
            return (nil, nil)
        }
        
        if json is [String:Any] {
            return (Reflect<T>.mapObject(json: json as AnyObject?), nil)
        } else if json is [[String:Any]] {
            return (nil, Reflect<T>.mapObjects(json: json as AnyObject?))
        }
        
        return (nil, nil)
    }
}

// MARK: - 请求接口
extension BaseRequest {
    
    /// 上传图片
    ///
    /// - Parameters:
    ///   - url: 接口
    ///   - images: 图片
    ///   - parameters: 参数
    ///   - isCheckNetStatus: true: 显示网络错误信息
    ///   - isCheckRequestError: true: 显示请求错误信息
    ///   - succeedRequest: 请求成功回调
    ///   - errorRequest: 请求错误回调
    ///   - failedRequest: 请求失败回调
    func UploadImage(_ url: String, images: [UIImage], parameters: [String: Any]?, isCheckNetStatus: Bool = true, isCheckRequestError: Bool = true, succeedRequest: @escaping RequestSucceed, errorRequest: @escaping RequestError, failedRequest: @escaping RequestFailure) {
     
        let request = serializer.multipartFormRequest(withMethod: "POST", urlString: url, parameters: parameters, constructingBodyWith: { (formData: AFMultipartFormData) in
            
            for (i, image) in images.enumerated() {
                
                let filename = "file\(i + 1).png"
                LogManager.shared.log("fileName ------ ----- --- :\(filename)")
                
                let imagedata = UIImageJPEGRepresentation(image, 0.9)!
                formData.appendPart(withFileData: imagedata, name: "image\(i + 1)", fileName: "file\(i + 1).png", mimeType: "image/jpeg")
            }
            
            }, error: nil)
        
        let uploadTask = sessionManager.dataTask(with: request as URLRequest, uploadProgress: { (uploadProgress: Progress) in
            
            let progress = Double(uploadProgress.completedUnitCount) / Double(uploadProgress.totalUnitCount)
            LogManager.shared.log("uploadProgress.completedUnitCount ------ ----- --- :\(uploadProgress.completedUnitCount)")
            LogManager.shared.log("uploadProgress.totalUnitCount ------ ----- --- :\(uploadProgress.totalUnitCount)")
            LogManager.shared.log("上传进度 ------ ----- --- :\(progress)")
            
            BFunction.shared.showProgress(progress, msg: "已完成\(Int(progress * 100))%")
            
            }, downloadProgress: nil) { (response: URLResponse, any: Any?, error: Error?) in
                
                self.interceptResponse(response: response, any: any, error: error, isCheckNetStatus: isCheckNetStatus, isCheckRequestError: isCheckRequestError, succeedRequest: succeedRequest, errorRequest: errorRequest, failedRequest: failedRequest)
        }
        
        uploadTask.resume()
    }
    
    /// POST(其他接口用这个方法)
    ///
    /// - Parameters:
    ///   - url: 接口
    ///   - parameters: 参数
    ///   - isCheckNetStatus: true: 显示网络错误信息
    ///   - succeedRequest: 请求成功回调
    ///   - failedRequest: 请求失败回调
    func POST(_ url: String, parameters: Any?, isCheckNetStatus: Bool = true, succeedRequest: @escaping RequestSucceed, failedRequest: @escaping RequestFailure) {
        
        let request = serializer.request(withMethod: "POST", urlString: url, parameters: parameters, error: nil)
        let task = sessionManager.dataTask(with: request as URLRequest) { (response: URLResponse, any: Any?, error: Error?) in
            
            if let error = error {
                failedRequest(response, error)
                
                if  isCheckNetStatus {
                    self.check(netWork: error)
                }
            }else{
                
                succeedRequest(response, any, false)
            }
        }
        
        task.resume()
    }
    
    /// POST
    ///
    /// - Parameters:
    ///   - url: 接口
    ///   - parameters: 参数
    ///   - isCheckNetStatus: true: 显示网络错误信息
    ///   - isCheckRequestError: true: 显示请求错误信息
    ///   - succeedRequest: 请求成功回调
    ///   - errorRequest: 请求错误回调
    ///   - rqEmptyData: 空数据回调
    ///   - failedRequest: 请求失败回调
    func POST(_ url: String, parameters: Any?, isCheckNetStatus: Bool = true, isCheckRequestError: Bool = true, succeedRequest: @escaping RequestSucceed, errorRequest: @escaping RequestError, failedRequest: @escaping RequestFailure) {
        
        request(with: "POST", url: url, parameters: parameters, isCheckNetStatus: isCheckNetStatus, isCheckRequestError: isCheckRequestError, succeedRequest: succeedRequest, errorRequest: errorRequest, failedRequest: failedRequest)
    }
    
    /// GET
    ///
    /// - Parameters:
    ///   - url: 接口
    ///   - parameters: 参数
    ///   - succeedRequest: 请求成功回调
    ///   - errorRequest: 请求错误回调
    ///   - rqEmptyData: 空数据回调
    ///   - failedRequest: 请求失败回调
    func GET(_ url: String, parameters: Any?, isCheckNetStatus: Bool = true, isCheckRequestError: Bool = true, succeedRequest: @escaping RequestSucceed, errorRequest: @escaping RequestError, failedRequest: @escaping RequestFailure) {
        
        request(with: "GET", url: url, parameters: parameters, isCheckNetStatus: isCheckNetStatus, isCheckRequestError: isCheckRequestError, succeedRequest: succeedRequest, errorRequest: errorRequest, failedRequest: failedRequest)
    }
    
    fileprivate func request(with method: String, url: String, parameters:Any?, isCheckNetStatus: Bool = true, isCheckRequestError: Bool = true, succeedRequest: @escaping RequestSucceed, errorRequest: @escaping RequestError, failedRequest: @escaping RequestFailure) {
        
        let request = serializer.request(withMethod: method, urlString: url, parameters: parameters, error: nil)
        let task = sessionManager.dataTask(with: request as URLRequest) { (response: URLResponse, any: Any?, error: Error?) in
            
            self.interceptResponse(response: response, any: any, error: error, isCheckNetStatus: isCheckNetStatus, isCheckRequestError: isCheckRequestError, succeedRequest: succeedRequest, errorRequest: errorRequest, failedRequest: failedRequest)
        }
        
        task.resume()
    }
    
    fileprivate func interceptResponse(response: URLResponse, any: Any?, error: Error?, isCheckNetStatus: Bool = true, isCheckRequestError: Bool = true, succeedRequest: @escaping RequestSucceed, errorRequest: @escaping RequestError, failedRequest: @escaping RequestFailure) {
        
        LogManager.shared.log("请求到的数据 －－－－－－－－－ \n \(any)")
        
        if let error = error {
            
            failedRequest(response, error)
            
            if  isCheckNetStatus {
                self.check(netWork: error)
            }
        } else {
            
            if let dic = any as? [String: Any],
                let object = RootModel(dic: dic),
                let status = object.status,
                let msg = object.message,
                let data = object.result {
                
                switch (status) {
                case 315:
                    
                    BFunction.shared.hideLoadingMessage()
                    
                    AccountManager.shared.logoutAccount(callBack: {
                        
                        BFunction.shared.showAlert(title: "提示", subTitle: "您的身份令牌已过期，请重新登录", cancelBtnTitle: "重新登录", cancelBtnAction: {
                            
                            AccountManager.shared.gotoLogin()
                        })
                    })
                case 316:
//                    let m = ErrorModel(status: status, message: msg)
//                    
//                    if isCheckRequestError {
//                        BFunction.shared.showErrorMessage(msg)
//                    }
//                    
//                    errorRequest(response, m)
                    
                    BFunction.shared.hideLoadingMessage()
                    
                    AccountManager.shared.logoutAccount(callBack: {
                        
                        if !(UIApplication.sharedDelegate().window?.rootViewController is LoginNavC) {
          
                            BFunction.shared.showAlert(title: "提示", subTitle: "您的身份令牌已过期，请重新登录", cancelBtnTitle: "重新登录", cancelBtnAction: {
                                
                                AccountManager.shared.gotoLogin()
                            })
                        }
                    })
                    
                    BaseRequest.shared.getServerTime { (time) in
                        
                        _ = UDManager.shared.saveServerTime(time)
                    }
                case 200:
                    
                    succeedRequest(response, data, object.hasMore)
                default:
                    
                    let m = ErrorModel(status: status, message: msg)
                    
                    if isCheckRequestError {
                        BFunction.shared.showErrorMessage(m.message)
                    }
                    
                    errorRequest(response, m)
                }
            } else {
                let m = ErrorModel(status: -11211, message: "未知的错误")
                errorRequest(response, m)
            }
        }
    }
}

extension BaseRequest {
    
    /// 默认请求参数
    ///
    /// - Returns: [String: Any]
    func postParameters() -> [String: Any] {
        
        var parameters = [String: Any]()
        
        let serverTime = UDManager.shared.serverTime()
        if let serverTime = serverTime {
            parameters["timeJob"] = Int(serverTime)
        }
        
        let deviceToken = UDManager.shared.pushToken()
        parameters["deviceId"] = deviceToken
        
        let nonstr = Utility.randomStringWithLength(8)
        parameters["nonstr"] = nonstr
        
        if let account = AccountManager.shared.account {
            parameters["uId"] = account.id
        }
        
        return parameters
    }
    
    /// 判断网络状态
    ///
    /// - Parameter isTip: 是否显示提示信息
    /// - Returns: true：网络可用
    func isNetworkReachableWithTip(_ isTip: Bool) -> Bool {
        
        if !isNetWorkUsable && isTip {
            BFunction.shared.showErrorMessage("似乎已和网络断开了连接")
        }
        
        return isNetWorkUsable
    }
    
    /// 检查网络错误状态
    ///
    /// - Parameter error: Error
    func check(netWork error: Error) {
        LogManager.shared.log(error._code, msg: error.localizedDescription)
        
        switch error._code {
        case -1009: BFunction.shared.showErrorMessage("似乎已和网络断开了连接")
        case -1004: BFunction.shared.showErrorMessage("与服务器断开连接")
        case -999 : LogManager.shared.log("服务器主动断开网络请求")
        case -1001: BFunction.shared.showErrorMessage(tipNetTimeOut)
        case -1011: BFunction.shared.showErrorMessage("攻城狮正在抢修服务器...")
        default   : BFunction.shared.showErrorMessage(tipNetError)
        }
    }
}
