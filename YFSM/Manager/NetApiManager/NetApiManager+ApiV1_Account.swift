//
//  NetApiManager+ApiV1_Account.swift
//  demo-swift
//
//  Created by Alvin on 16/4/9.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import Foundation
import AFNetworking

extension BaseRequest {
    
    /// 用户登录
    ///
    /// - Parameters:
    ///   - studentNo: 帐号
    ///   - password: 密码
    ///   - completion: StudentModel
    func userLogin(_ studentNo: String, password: String, completion: @escaping (_ result: Any?) -> Void, errorRequest: RequestError?, failedRequest: RequestFailure?) {
        
        let action = "http://hi-watch.com.cn/tpiot/app/login"
        
        var parameters = [String: Any]()
        parameters["username"] = studentNo
        parameters["password"] = password.mattress_MD5()
        
        LogManager.shared.log("提交的参数 ＝＝＝＝ \(parameters)")
        
        let url = action
        POST(url, parameters: parameters, succeedRequest: { (response, responseObject, hasMore) -> Void in
            
            LogManager.shared.log("登录回执数据: \(responseObject)")
            
            if let json = responseObject as? [String: Any] {
                AccountManager.shared.login(json, firstLogin: true)
                completion(json)
            }
        }, errorRequest: { (response, errorObject) -> Void in
            
            errorRequest?(response, errorObject)
        }, failedRequest: { (response, error) -> Void in
            
            failedRequest?(response, error)
        })
    }
    
    
    
    /// 我的用户信息
    ///
    /// - Parameter completion: StudentModel
    func userDetailInfo(_ completion: @escaping (_ model: StudentModel?) -> Void) {
        
        if let account = AccountManager.shared.account {
            completion(account)
        }
        
        let action = "/app/student/userInfor"
        userInfo(action, uid: nil, nick: nil, note: nil, completion: completion, errorRequest: nil, failedRequest: nil)
    }
    
    /// 用户详情
    ///
    /// - Parameters:
    ///   - id: 用户ID
    ///   - completion: StudentModel
    ///   - errorRequest: 请求错误回调
    func userDetailInfo(_ id: Int, completion: @escaping (_ model: StudentModel?) -> Void, failedRequest: RequestFailure?) {
        
        let action = "/app/student/getById"
        userInfo(action, uid: id, nick: nil, note: nil, completion: completion, errorRequest: nil, failedRequest: failedRequest)
    }
    
    /// 修改用户昵称
    ///
    /// - Parameters:
    ///   - nick: 用户昵称
    ///   - completion: StudentModel
    func userUpdateNickName(_ nick: String, completion: @escaping (_ model: StudentModel?) -> Void) {
        
        let action = "/app/student/updateNick"
        userInfo(action, uid: nil, nick: nick, note: nil, completion: completion, errorRequest: nil, failedRequest: nil)
    }
    
    /// 修改用户简介
    ///
    /// - Parameters:
    ///   - note: 用户简介
    ///   - completion: StudentModel
    func userUpdateField(_ note: String, completion: @escaping (_ model: StudentModel?) -> Void) {
        
        let action = "/app/student/updateField"
        userInfo(action, uid: nil, nick: nil, note: note, completion: completion, errorRequest: nil, failedRequest: nil)
    }
    
    /// 摇一摇花名
    ///
    /// - Parameters:
    ///   - completion: StudentModel
    ///   - errorRequest: 请求错误回调
    func userUpdateRoster(_ completion: @escaping (_ model: StudentModel?) -> Void, errorRequest: RequestError?) {
        
        let action = "/app/student/updateRoterName"
        userInfo(action, uid: nil, nick: nil, note: nil, completion: completion, errorRequest: errorRequest, failedRequest: nil)
    }
    
    /**
     获取用户信息 (userDetailInfo, userUpdateField, userUpdateRoster)
     
     - parameter uid:        用户id，不传是获取自己
     - parameter action:     接口
     - parameter completion: 结果回调
     */
    
    /// 用户信息
    ///
    /// - Parameters:
    ///   - action: 接口 (userDetailInfo, userUpdateField, userUpdateRoster)
    ///   - uid: 用户id，不传是获取自己
    ///   - nick: 用户昵称（userUpdateNickName）
    ///   - note: 用户简介（userUpdateField）
    ///   - completion: StudentModel
    ///   - errorRequest: 请求错误回调
    fileprivate func userInfo(_ action: String, uid: Int?, nick: String?, note: String?, completion: @escaping (_ model: StudentModel?) -> Void, errorRequest: RequestError?, failedRequest: RequestFailure?) {
        
        var parameters = postParameters()
        if let p = uid { parameters["id"] = p }
        if let p = nick { parameters["nick"] = p }
        if let p = note { parameters["note"] = p }
        
        // 需要加密的Dic
        let signDic = parameters + ["url":action]
        // 进行Dic排序后字符串拼接
        let sortStr = Utility.sort(with: signDic)
        // MD5加密
        let signMD5 = sortStr.mattress_MD5()
        
        guard let sign = signMD5 else { LogManager.shared.log("MD5加密失败"); return }
        
        LogManager.shared.log("加密后的 ＝＝＝＝ \(sign)")
        parameters["sign"] = sign
        
        LogManager.shared.log("提交的参数 ＝＝＝＝ \(parameters)")
        
        let url = self.apiURL + action
        POST(url, parameters: parameters, isCheckRequestError: errorRequest == nil, succeedRequest: { (response, responseObject, hasMore) -> Void in
            
            LogManager.shared.log("用户详情回执数据: \(responseObject)")
            
            if let json = responseObject as? [String: Any] {
                
                var model = self.getObject(with: json, object: StudentModel()).0
                
                if let modelDic = json["studentVo"] as? [String: Any] {//遥花名
                    
                    AccountManager.shared.login(modelDic)
                    model = self.getObject(with: modelDic, object: StudentModel()).0
                    completion(model)
                }else{
                    
                    if !(action == "/app/student/getById") {
                        AccountManager.shared.login(json)
                    }
                    
                    completion(model)
                }
            }
        }, errorRequest: { (response, errorObject) -> Void in
            
            errorRequest?(response, errorObject)
        }, failedRequest: { (response, error) -> Void in
            
            failedRequest?(response, error)
        })
    }
    
    
    
    /// 修改用户头像
    ///
    /// - Parameters:
    ///   - image: 用户头像
    ///   - completion: StudentModel
    func userUploadHeadPic(_ image: UIImage, completion: @escaping (_ model: StudentModel?) -> Void) {
        
        let action = "/app/student/uploadUserHead"
        
        var parameters = postParameters()
        
        // 需要加密的Dic
        let signDic = parameters + ["url":action]
        // 进行Dic排序后字符串拼接
        let sortStr = Utility.sort(with: signDic)
        // MD5加密
        let signMD5 = sortStr.mattress_MD5()
        
        guard let sign = signMD5 else { LogManager.shared.log("MD5加密失败"); return }
        
        LogManager.shared.log("加密后的 ＝＝＝＝ \(sign)")
        parameters["sign"] = sign
        
        LogManager.shared.log("提交的参数 ＝＝＝＝ \(parameters)")
        
        let url = self.apiURL + action
        UploadImage(url, images: [image], parameters: parameters, succeedRequest: { (response, responseObject, hasMore) in
            
            LogManager.shared.log("修改头像回执数据: \(responseObject)")
            
            if let json = responseObject as? [String: Any] {
                AccountManager.shared.login(json)
                
                let model = self.getObject(with: json, object: StudentModel()).0
                completion(model)
            }
        }, errorRequest: { (response, errorObject) -> Void in
            
        }, failedRequest: { (response, error) -> Void in
            
        })
    }
    
    /// 关注用户
    ///
    /// - Parameters:
    ///   - reStudentId: 要关注的用户ID
    ///   - completion: StudentModel
    func userFollow(_ reStudentId: Int, completion: @escaping (_ model: StudentModel?) -> Void) {
        
        let action = "/app/student/follow"
        
        var parameters = postParameters()
        parameters["reStudentId"] = reStudentId
        
        // 需要加密的Dic
        let signDic = parameters + ["url":action]
        // 进行Dic排序后字符串拼接
        let sortStr = Utility.sort(with: signDic)
        // MD5加密
        let signMD5 = sortStr.mattress_MD5()
        
        guard let sign = signMD5 else { LogManager.shared.log("MD5加密失败"); return }
        
        LogManager.shared.log("加密后的 ＝＝＝＝ \(sign)")
        parameters["sign"] = sign
        
        LogManager.shared.log("提交的参数 ＝＝＝＝ \(parameters)")
        
        let url = self.apiURL + action
        POST(url, parameters: parameters, succeedRequest: { (response, responseObject, hasMore) -> Void in
            
            LogManager.shared.log("关注用户回执数据: \(responseObject)")
            
            let model = self.getObject(with: responseObject, object: StudentModel()).0
            completion(model)
        }, errorRequest: { (response, errorObject) -> Void in
            
        }, failedRequest: { (response, error) -> Void in
            
        })
    }

  }
