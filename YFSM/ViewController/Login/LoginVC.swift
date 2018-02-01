//
//  LoginVC.swift
//  DigitalCampus
//
//  Created by luo on 16/4/23.
//  Copyright © 2016年 luo. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
class LoginVC: BaseVC {
    
    @IBOutlet weak var _numberTextField: UITextField!
    @IBOutlet weak var _passwordTextField: UITextField!
    @IBOutlet weak var _loginButton: UIButton!
    @IBOutlet weak var _registerBtn: UIButton!
    
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _registerBtn.layer.borderColor = UIColor.cyan.cgColor
        _registerBtn.layer.borderWidth = 1.0

        _registerBtn.layer.masksToBounds = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func toRegister(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
      self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
//        let net = NetWork.init();
//        net.getlogin();
        if _numberTextField.text?.length != 11 {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号")
            return
        }
        if _passwordTextField.text?.length == 0 {
            SVProgressHUD.showError(withStatus: "请输入密码")
            return
        }
//        let urlString = "http://hi-watch.com.cn/tpiot/app/login"
        let urlString = api_service+"/login"
    
        var parameters = [String: Any]()
        parameters["username"] = _numberTextField.text
        parameters["password"] = _passwordTextField.text?.mattress_MD5();
        BFunction.shared.showLoading()
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            BFunction.shared.hideLoadingMessage()
            if response.error != nil  {
                SVProgressHUD.showError(withStatus: "登录失败")
                return
            }
            if let jsonResult = response.value as? Dictionary<String, Any> {
                if jsonResult["result"] as! Int == 0 {
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(self._numberTextField.text, forKey: "UserPhone")
                    userDefaults.setValue(self._passwordTextField.text, forKey: "UserPassword")
                    let userId:String = "\(String(describing: jsonResult["userid"]!))";
                    userDefaults.set(userId, forKey: "userid")
                    userDefaults.synchronize()
                    AccountManager.shared.login(response.value as! [String : Any], firstLogin: false)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
                    appDelegate.window?.rootViewController = BaseNavC(rootViewController: homeVC)
                }else {
                    SVProgressHUD.showError(withStatus: "登录失败")
                }
            }

        }
//        NetworkTools.shareInstance.request(methodType: .POST, urlString: urlString, parameters:parameters as [String : AnyObject]) { (result : AnyObject?, error : Error?) in
//            BFunction.shared.hideLoadingMessage()
//            if error != nil  {
//                print(error!)
//                SVProgressHUD.showError(withStatus: "登录失败")
//                return
//            }
//            if let jsonResult = result as? Dictionary<String, Any> {
//                if jsonResult["result"] as! Int == 0 {
//                    AccountManager.shared.login(result as! [String : Any], firstLogin: false)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
//                    appDelegate.window?.rootViewController = BaseNavC(rootViewController: homeVC)
//                }else {
//
//                    SVProgressHUD.showError(withStatus: "登录失败")
//                }
//            }
//
//        }
    }
    
}

