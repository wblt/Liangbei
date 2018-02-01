//
//  WaterOilListVC.swift
//  YFSM
//
//  Created by yanghuan on 2018/2/1.
//  Copyright © 2018年 wb. All rights reserved.
//

import UIKit
import MJExtension
import Alamofire
import SVProgressHUD

class WaterOilListVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

		getdata()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// 从服务器获取
	func getdata(){
		var parameters = [String: Any]()
		BFunction.shared.showLoading()
		let urlString = api_service + "/getmask"
		let userDefaults = UserDefaults.standard
		parameters["userid"] = userDefaults.value(forKey: "userid")
		parameters["page"] = "0";
		parameters["pagesize"] = "10";
		Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
			BFunction.shared.hideLoadingMessage()
			if response.error != nil  {
				SVProgressHUD.showError(withStatus: getLocalizableString(key: "mask_data_fail", common: "获取面膜数据失败") )
				return
			}
			if let jsonResult = response.value as? Dictionary<String, Any> {
				if jsonResult.count == 0 {
					 // self.initEView(flag: "1");
				} else {
					if jsonResult["result"] as! Int == 0 {
						SVProgressHUD.showInfo(withStatus: getLocalizableString(key: "mask_data_success", common: "获取面膜数据成功") )
						let data:Array<Dictionary> = jsonResult["data"] as! Array<Dictionary<String,Any>>;
						var fatherArray:[TimeDataModel] = [TimeDataModel]()
						var sonArray:[FaceDataModel] = [FaceDataModel]()
						
						
						for (index,value) in data.enumerated() {
							// 这样子遍历，可以得到数组的值和下标
							print("index:\(index) = \(value)")
							
							let model:FaceDataModel = FaceDataModel.mj_object(withKeyValues: value);
							sonArray.append(model);
							
							if sonArray.count < 5 && index != data.count-1{
								continue;
							}
							
							let timeModel:TimeDataModel = TimeDataModel()
							let firstModel:FaceDataModel = sonArray.first!
							let lastModel:FaceDataModel = sonArray.last!
							
							timeModel.startTime = firstModel.time
							timeModel.endTime = lastModel.time
							timeModel.data = sonArray
							fatherArray.append(timeModel)
							sonArray .removeAll()
							
						}
						//获取到 cell数据
						print(fatherArray)
						
						
					}else {
						SVProgressHUD.showError(withStatus: getLocalizableString(key: "mask_data_fail", common: "获取面膜数据失败") )
					}
				}
				
			}
			
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
