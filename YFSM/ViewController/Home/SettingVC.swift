//
//  SettingVC.swift
//  YFSM
//
//  Created by wb on 2018/1/23.
//  Copyright © 2018年 wb. All rights reserved.
//

import UIKit

class SettingVC: BaseVC,UIAlertViewDelegate  {
    
    
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var jiaochengView: UIView!
    
    @IBOutlet weak var shuiyoubiaoView: UIView!
    
    @IBOutlet weak var dailiView: UIView!
    
    @IBOutlet weak var shangchengView: UIView!
    
    @IBOutlet weak var yijianView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "管理";
        // Do any additional setup after loading the view.
        self.logoutView.tag = 101;
        self.jiaochengView.tag = 102;
        self.shuiyoubiaoView.tag = 103;
        self.dailiView.tag = 104;
        self.shangchengView.tag = 105;
        self.yijianView.tag = 106;
        
        let tap1 = UITapGestureRecognizer(target:self, action:#selector(self.btnClickss(sender:)))
        let tap2 = UITapGestureRecognizer(target:self, action:#selector(self.btnClickss(sender:)))
        let tap3 = UITapGestureRecognizer(target:self, action:#selector(self.btnClickss(sender:)))
        let tap4 = UITapGestureRecognizer(target:self, action:#selector(self.btnClickss(sender:)))
        let tap5 = UITapGestureRecognizer(target:self, action:#selector(self.btnClickss(sender:)))
        let tap6 = UITapGestureRecognizer(target:self, action:#selector(self.btnClickss(sender:)))
        //设置view可以点击
        self.logoutView.isUserInteractionEnabled=true
        self.jiaochengView.isUserInteractionEnabled = true;
        self.shuiyoubiaoView.isUserInteractionEnabled = true;
        self.dailiView.isUserInteractionEnabled = true;
        self.shangchengView.isUserInteractionEnabled = true;
        self.yijianView.isUserInteractionEnabled = true;
        //给view添加事件
        self.logoutView.addGestureRecognizer(tap1)
        self.jiaochengView.addGestureRecognizer(tap2);
        self.shuiyoubiaoView.addGestureRecognizer(tap3);
        self.dailiView.addGestureRecognizer(tap4);
        self.shangchengView.addGestureRecognizer(tap5);
        self.yijianView.addGestureRecognizer(tap6);
    }
    
    @objc func btnClickss(sender:UIGestureRecognizer) {
        let tag:Int = (sender.view?.tag)!;
        print(sender.view?.tag as Any)
        if tag == 101 {
            let alrtView = UIAlertView(title: "温馨提示", message: "是否确定退出？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alrtView.show()
        } else if tag == 102 {
            NavigationManager.pushToNativeWebView(form: self, fileName: "operation", title: "更多" )
        } else if tag == 103 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let chatVC = storyboard.instantiateViewController(withIdentifier: "GoChartSegueIdentifier") as! ChartVC
            self.navigationController?.pushViewController(chatVC, animated: true)
        } else if tag == 104 {
            // 代理
            let url:String = "http://www.hi-watch.com.cn/weixin/shop/agent";
            NavigationManager.pushToWebView(form: self, url: url)
        } else if tag == 105 {
            // 商城
            let userDefaults = UserDefaults.standard
            let phone:String = userDefaults.value(forKey: "UserPhone") as! String
            let url:String = "http://www.hi-watch.com.cn/weixin/shop/shopList?openid="+phone;
            NavigationManager.pushToWebView(form: self, url: url)
        } else if tag == 106 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let suggestionsVC = storyboard.instantiateViewController(withIdentifier: "SuggestionsVC") as! SuggestionsVC
            self.navigationController?.pushViewController(suggestionsVC, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        if buttonIndex == 1 {
            let bools = UDManager.shared.removeUserToken()
            print(bools)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
            appDelegate.window?.rootViewController = BaseNavC(rootViewController: loginVC)
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
