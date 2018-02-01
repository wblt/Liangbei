//
//  BaseVC.swift
//  HangJia
//
//  Created by Alvin on 16/1/7.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit
import MJRefresh
import BFEmptyDataSet

enum EmptyPageType {
    case netError, emptyData, emptyComment
}

class BaseVC: UIViewController, UITextFieldDelegate {
    let TAG_LeftButton = 10001
    var backgroundView: UIImageView!
    /// 网络请求页数
    var pageNumber = 1
    var emptyPageType = EmptyPageType.netError
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackItem()
        setupBgView()
        
        // 注册通知
        registerNotifi()
        
        // ios7适配避免上方空白
        if self.responds(to: #selector(setter: UIViewController.automaticallyAdjustsScrollViewInsets)) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        let leftBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.btnClick(_:)))
        leftBtn.tag = TAG_LeftButton
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    @objc func btnClick(_ sender:AnyObject) {
        if sender.tag == TAG_LeftButton {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
       // backgroundView.frame = self.view.bounds
    }
    
    // MARK: - deinit
    deinit {
        BFunction.shared.hideLoadingMessage()
        removeNotifi()
        BaseRequest.shared.stopAllAfRequestMgrRequest()
        LogManager.shared.log("\(self.classForCoder) deinit")
    }
}

// MARK: - event、response
extension BaseVC {
    
    /**
     返回上一页
     */
    @objc func mainBackPage() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc  func notificationReceive(_ aNotification: Notification) {
        
        LogManager.shared.log("收到通知，通知名字是 == \(aNotification.name.rawValue)")
    }
}

// MARK: - delegate
extension BaseVC: BFEmptyDataSetSource {
    
//    func title(forEmptyDataSet view: UIView!) -> NSAttributedString! {
//        
//        let text = isEmptyData ? "空空如也~" : "网络加载失败，请点击重试"
//        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColorHex("#")]
//        
//        let attribute = NSAttributedString(string: text, attributes: attributes)
//        
//        return attribute
//    }
    
//    func description(forEmptyDataSet view: UIView!) -> NSAttributedString! {
//        
//        let text = isEmptyData ? "" : "请检查您的网络设置或点击重试"
//        let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColorHex("#")]
//        
//        let attribute = NSAttributedString(string: text, attributes: attributes)
//        
//        return attribute
//    }
    
    func customView(forEmptyDataSet view: UIView!) -> UIView! {
        
        let customView = UIView(frame: view.bounds)
        
        let imageViewX = ConvertToBigScreen(88)
        let imageViewW = view.bounds.width - (2 * imageViewX)
        let imageViewY = (view.bounds.height - 15 - 21 - imageViewW) / 2//ConvertToBigScreen(110)
        
        let imageView = UIImageView(frame: CGRect(x: imageViewX, y: imageViewY, width: imageViewW, height: imageViewW))
        
        var image: UIImage!
        
        switch emptyPageType {
        case .netError:
            image = UIImage(named: "netError")
        case .emptyData:
            image = UIImage(named: "noData_Big")
        case .emptyComment:
            image = UIImage(named: "noData_Big")
        }
        
        imageView.image = image
        customView.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: 0, y: imageViewY + imageViewW + 15, width: view.bounds.width, height: 21))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColorHex("#4A4A4A")
        
        var text: String!
        
        switch emptyPageType {
        case .netError:
            text = "网络加载失败，请点击重试"
        case .emptyData:
            text = "空空如也~"
        case .emptyComment:
            text = "客官快把评论放碗里吧~~"
        }
        
        label.text = text
        label.textAlignment = .center
        customView.addSubview(label)
        
        return customView
    }
    
//    func image(forEmptyDataSet view: UIView!) -> UIImage! {
//        
//        return isEmptyData ? UIImage(named: "noData_Big") : UIImage(named: "netError")
//    }
    
//    func spaceHeight(forEmptyDataSet view: UIView!) -> CGFloat {
//        
//        return 15
//    }
}

extension BaseVC: BFEmptyDataSetDelegate {
    
}

// MARK: - getters、setters
extension BaseVC {
    
    func setupBackItem() {
        
        // 子页面返回按钮的名称
        if let c = navigationController?.viewControllers.count , c > 1 {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backPage"), style: .plain, target: self, action: #selector(BaseVC.mainBackPage))
        }
    }
    
    fileprivate func setupBgView() {
        
      /*  backgroundView = UIImageView(image: UIImage(named: "background"))
        backgroundView.frame = CGRect(x: 0, y: 0, width: kScreenFrameW, height: kScreenFrameH)
        backgroundView.isUserInteractionEnabled = true
        self.view.insertSubview(backgroundView, at: 0)*/
    }
    
    /// 设置网络错误，空数据背景
    func setupErrorBgView() {
        
        backgroundView.emptyDataSetSource = self
        backgroundView.emptyDataSetDelegate = self
    }
    /// 显示网络错误，空数据背景
    func showErrorBgView() {
        pageNumber = 1
        BFunction.shared.hideLoadingMessage()
        backgroundView.reloadEmptyDataSet()
    }
    
    
    /// 移除网络错误，空数据背景
    func removeErrorBgView() {
        
        backgroundView.removeEmptyDataSet()
    }
    
    /// 设置上拉，下拉刷新
    func setupRefresh(_ taget: UIScrollView, headerCallback: (()->Void)?, footerCallBack: (()->Void)?) {
        
        if let callback = headerCallback {
            
            taget.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                
                self?.pageNumber = 1
                taget.mj_footer.isHidden = true
                taget.mj_footer.resetNoMoreData()
                callback()
            })
        }
        
        if let callback = footerCallBack {
            
            let footer = MJRefreshBackStateFooter(refreshingBlock: { [weak self] in
                
                self?.pageNumber += 1
                callback()
            })
            footer?.setTitle("已经到底啦～", for: MJRefreshState.noMoreData)
            footer?.isHidden = true
            
            taget.mj_footer = footer
        }
    }
    
    // MARK: - 注册用户登录，登出通知
    fileprivate func registerNotifi() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceive(_:)), name: NSNotification.Name(rawValue: cNDidLogin), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceive(_:)), name: NSNotification.Name(rawValue: cNRefreshUserInfo), object: nil)
    }
    
    // MARK: - 移除通知
    fileprivate func removeNotifi() {
        NotificationCenter.default.removeObserver(self)
    }
}
