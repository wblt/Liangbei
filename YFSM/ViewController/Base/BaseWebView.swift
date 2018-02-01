//
//  BaseWebview.swift
//  HangJia
//
//  Created by Alvin on 16/2/22.
//  Copyright © 2016年 Alvin. All rights reserved.
//

import UIKit
import WebKit

class BaseWebView: BaseVC {
    
    fileprivate var loadURLString: String!
    fileprivate var loadFileName:String!
    fileprivate var navTitle = ""
    fileprivate var _webView: WKWebView!
    fileprivate var _progressView: UIProgressView!
    fileprivate var loadCount: Float = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    var webViewHeight: CGFloat = 0// webView加载完成后的高度
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        /*self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.setNavigationBarHidden(false, animated: true)*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = navTitle
        if navTitle.isEmpty {
            self.navigationItem.title = "加载中..."
        }
        setupWebView()
        setupProgressView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        _webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

// MARK: - event、response
extension BaseWebView {
    
    /**
     加载连接
     
     - parameter urlString: 连接
     */
    func loadUrlString(_ urlString: String, title: String) {
        
        loadURLString = urlString
        navTitle = title
    }
    
    /**
     加载本地文件
     
     - parameter urlString: 连接
     */

    func loadFileName(_ fileName: String, title: String) {
        loadFileName = fileName
        navTitle = title
    }
    
    

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            
            if let newprogress = change?[NSKeyValueChangeKey.newKey] as? Double, _progressView != nil {
               
                if (newprogress == 1) {
                    _progressView.isHidden = true
                    _progressView.setProgress(0, animated: false)
                }else {
                    _progressView.isHidden = false
                    _progressView.setProgress(Float(newprogress), animated: true)
                }
            }
        }
    }
}

// MARK: - delegate
extension BaseWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadCount += 1
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        loadCount -= 1
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadCount -= 1
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webViewHeight = webView.scrollView.contentSize.height
        
        if navTitle.isEmpty {
            setNavagationBar()
        }
        
        // 禁用webview长按功能
        _webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        _webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = webView.url?.absoluteString, url.hasPrefix("https://itunes.apple.com") {
            
            UIApplication.shared.openURL(URL(string: url)!)
            decisionHandler(WKNavigationActionPolicy.cancel)
        }else{
            
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
}

extension BaseWebView: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "DigitalCampusWebApp" {
            
            LogManager.shared.log("\(message.body)")
            
            if let body = message.body as? String,
                let dic = body.toData()?.toDictionary(),
                let content = dic["content_url"] as? String,
                let method = dic["method"] as? String {
                
                if method == "detail" {
                    
                    NavigationManager.pushToWebView(form: self, url: content)
                } else if method == "phone" {
                    
                    BFunction.shared.showAlert(title: "是否拨打电话?", subTitle: content, ontherBtnTitle: "拨打", ontherBtnAction: { 
                        
                        DeviceManager.shared.openCall(phone: content)
                    })
                }
            }
        }
    }
}

// MARK: - getters、setters
extension BaseWebView {
    
    /**
     设置标题
     */
    fileprivate func setNavagationBar() {
        
        _webView.evaluateJavaScript("document.title", completionHandler: { [weak self] (obj, error) in
        
            if let pageTitle = obj as? String {
                
                self?.navigationItem.title = pageTitle
            }
        })
    }
    
    fileprivate func setupWebView() {
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: "DigitalCampusWebApp")
        
        let rect = CGRect(x: 0, y: 64, width: kScreenFrameW, height: kScreenFrameH - 64)
        _webView = WKWebView(frame: rect, configuration: config)
        _webView.navigationDelegate = self
        _webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        self.view.addSubview(_webView)
        
        
        if loadFileName != nil {
            let path = Bundle.main.path(forResource: loadFileName, ofType: "html")
            if (path != nil) {
                do {
                    let htmlContent = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                    
                    // let baseURL = URL(fileURLWithPath: path)
                    _webView.loadHTMLString(htmlContent, baseURL: nil)
                    
                }catch let error {
                    
                    LogManager.shared.log("\(error)")
                }
            }
        
        }
        
        else if loadURLString != nil {
            let request = URLRequest(url: URL(string: loadURLString)!)
            _webView.load(request)
        }
        
        
    }
    
    fileprivate func setupProgressView() {
        
        _progressView = UIProgressView(frame: CGRect(x: 0, y: 64, width: kScreenFrameW, height: 0))
        _progressView.progressTintColor = themeColor
        _progressView.trackTintColor = UIColor.white
        self.view.addSubview(_progressView)
    }
    
    fileprivate func updateProgress() {
        
        LogManager.shared.log(loadCount)
        
        if loadCount == 1.0 {
            _progressView.isHidden = true
            _progressView.setProgress(0, animated: false)
        }else{
//            _progressView.isHidden = false
//            
//            let oldP = _progressView.progress
//            var newP = (1.0 - oldP) / (loadCount + 1) + oldP
//            
//            if newP > 0.95 {
//                newP = 0.95
//            }
//            
//            _progressView.setProgress(newP, animated: false)
        }
    }
}
