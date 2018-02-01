//
//  SuggestionsVC.swift
//  YFSM
//
//  Created by 何建波 on 2018/1/15.
//  Copyright © 2018年 wb. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class SuggestionsVC: BaseVC {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var phoneText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "意见反馈"
        textView.layer.borderColor = UIColor.lightGray.cgColor;
        textView.layer.borderWidth = 0.5;
        textView.layer.cornerRadius = 8;
        textView.layer.masksToBounds = true;
        
        phoneText.layer.borderColor = UIColor.lightGray.cgColor;
        phoneText.layer.borderWidth = 0.5;
        phoneText.layer.cornerRadius = 8;
        phoneText.layer.masksToBounds = true;
        phoneText.text = UserDefaults.standard.string(forKey: "UserPhone")
    }

    @IBAction func commitAction(_ sender: UIButton) {
        if textView.text?.length == 0 {
            SVProgressHUD.showError(withStatus: "请输入您的反馈意见")
            return
        }
        if phoneText.text?.length == 0 {
            SVProgressHUD.showError(withStatus: "请输入您的联系电话")
            return
        }
        let urlString = "http://hi-watch.com.cn/tpiot/app/usropinon"
        var parameters = [String: Any]()
        parameters["text"] = textView.text;
        parameters["contact"] = phoneText.text;
        parameters["deviceid"] = "863991033805702";
        BFunction.shared.showLoading()
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            BFunction.shared.hideLoadingMessage()
            if response.error != nil  {
                
                SVProgressHUD.showError(withStatus: "反馈失败")
                return
            }
            if let jsonResult = response.value as? Dictionary<String, Any> {
                if jsonResult["result"] as! Int == 0 {
                    self.navigationController?.popViewController(animated: true)
                    SVProgressHUD.showSuccess(withStatus: "反馈成功")
                }else {
                    
                    SVProgressHUD.showError(withStatus: "反馈失败")
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
