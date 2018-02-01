//
//  NetApiManager+ApiV1_App.swift
//  DigitalCampus
//
//  Created by blueskyplan on 16/8/6.
//  Copyright © 2016年 luo. All rights reserved.
//

import Foundation

extension BaseRequest {
    
    /// 获取服务器时间
    ///
    /// - Parameter completion: 服务器时间戳
    func getServerTime(_ completion: @escaping (_ time: TimeInterval) -> Void) {
        
        let url = self.apiURL + "/app/index/serverTime"
        POST(url, parameters: nil, succeedRequest: { (response, responseObject, hasMore) -> Void in
            
            LogManager.shared.log("获取服务器时间回执数据:   \(responseObject)")
            
            if let json = responseObject as? [String: TimeInterval],
                let time = json["serverTime"] {
                
                completion(time)
            }
        }, errorRequest: { (response, errorObject) -> Void in
        
        }, failedRequest: { (response, error) -> Void in
        
        })
    }
    
    /// 用户反馈
    ///
    /// - Parameters:
    ///   - contact: 联系方式
    ///   - note: 反馈内容
    ///   - images: 图片
    ///   - completion: isSuccess: 是否反馈成功 message: 提示信息
   /* func userFeedback(_ contact: String, note: String, images: [UIImage], completion: @escaping (_ isSuccess: Bool, _ message: String) -> Void) {
        
        let action = "/app/feedback/save"
        
        var parameters = postParameters()
        parameters["contact"] = contact
        parameters["content"] = note
        
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
        UploadImage(url, images: images, parameters: parameters, succeedRequest: { (response, responseObject, hasMore) in
            
            LogManager.shared.log("用户反馈回执数据: \(responseObject)")
            
            if let json = responseObject as? [String: Any],
                let isSuccess = json["result"] as? Int,
                let msg = json["message"] as? String {
                
                completion(isSuccess == 1, msg)
            }
        }, errorRequest: { (response, errorObject) -> Void in
            
        }, failedRequest: { (response, error) -> Void in
            
        })
    }*/
    
    /// 常见问题列表
    ///
    /// - Parameters:
    ///   - pageNum: 请求的页数，不能为空，第一页填1
    ///   - lastId: 上一次请求最后一条数据的ID，第一页填0
    ///   - completion: [FAQModel]
    ///   - emptyData: 空数据回调
    ///   - failedRequest: 请求失败回调
    func getFAQList(_ pageNum: Int, lastId: Int, completion: @escaping (_ data: [FAQModel]?, _ hasMore: Bool) -> Void, emptyData: RequestEmptyData?, failedRequest: RequestFailure?) {
        
        let action = "/app/problem/list"
        
        var parameters = postParameters()
        parameters["pageNum"] = pageNum
        parameters["pageSize"] = netPageSize
        parameters["lastId"] = lastId
        
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
            
            LogManager.shared.log("获取常见问题回执数据:   \(responseObject)")
            
            let modelArr = self.getObject(with: responseObject, object: FAQModel()).1
            completion(modelArr, hasMore)
        }, errorRequest: { (response, errorObject) -> Void in
            
            if errorObject.status == 4 {
                emptyData?()
            }
        }, failedRequest: { (response, error) -> Void in
            
            failedRequest?(response, error)
        })
    }
    
    /// 提示更新版本
    ///
    /// - Parameter completion: 结果回调
    /// - Parameter isNewVersion: true: 新版本
    /// - Parameter url: APP Store链接
   /* func showNewVersion(_ completion: @escaping (_ isNewVersion: Bool, _ url: String) -> Void) {
        
        let url = self.apiURL + "/app/index/getVersionBest"
        POST(url, parameters: nil, succeedRequest: { (response, responseObject, hasMore) -> Void in
            
            LogManager.shared.log("获取新版本回执数据:   \(responseObject)")
            
            if let json = responseObject as? [String: Any],
                let isTips = json["isTips"] as? Int {
                
                if isTips == 1 {
                    self.getAppStoreInfo({ (version, trackName, trackViewUrl) in
                        
                        completion(version > UIApplication.shared.appVersion(), trackViewUrl)
                    })
                }else{
                    completion(false, "")
                }
            }
        }, errorRequest: { (response, errorObject) -> Void in
            
        }, failedRequest: { (response, error) -> Void in
            
        })
    }*/
    
    /// 获取App Store上的APP信息
    ///
    /// - Parameter completion: 结果回调
    /// - Parameter version: App Store的APP版本号
    /// - Parameter trackName: App Store的APP名称
    /// - Parameter completion: App Store的APP链接
    fileprivate func getAppStoreInfo(_ completion: @escaping (_ version: String, _ trackName: String, _ trackViewUrl: String) -> Void) {
        
        POST("http://itunes.apple.com/cn/lookup?id=\(cAPPStoreID)", parameters: nil, succeedRequest: { (response, responseObject, hasMore) -> Void in
        
            if let json = responseObject as? [String:Any],
                let results = json["results"] as? [Any],
                let infoDic = results.first as? [String:Any] {
                
                if let latestVersion = infoDic["version"] as? String,
                    let trackViewUrl = infoDic["trackViewUrl"] as? String,
                    let trackName = infoDic["trackName"] as? String {
                    
                    completion(latestVersion, trackName, trackViewUrl)
                }else{
                    LogManager.shared.log("获取app信息解析失败")
                }
            }else{
                LogManager.shared.log("获取app信息失败")
            }
        }, failedRequest: { (response, error) -> Void in
        
        })
    }
}
