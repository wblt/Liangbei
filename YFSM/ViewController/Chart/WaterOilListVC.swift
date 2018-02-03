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
import MJRefresh

class WaterOilListVC: BaseVC , UITableViewDataSource, UITableViewDelegate{

	var table:UITableView!
	var timeDataArray:[TimeDataModel] = [TimeDataModel]()
	var faceDataArray:[FaceDataModel] = [FaceDataModel]()
	var page: Int = 0;
	
	// 顶部刷新
	let header = MJRefreshNormalHeader()
	// 底部刷新
	let footer = MJRefreshAutoNormalFooter()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.edgesForExtendedLayout = []
		
		self.table = UITableView(frame: self.view.bounds, style:UITableViewStyle.grouped)
		//设置数据源
		self.table.dataSource = self
		//设置代理
		self.table.delegate = self
		self.view.addSubview(self.table)
		//注册UITableView，cellID为重复使用cell的Identifier
		self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
//		// 下拉刷新
//		header.setRefreshingTarget(self, refreshingAction: Selector)
//		// 现在的版本要用mj_header
//		self.table.mj_header = header
//
//		// 上拉刷新
//		footer.setRefreshingTarget(self, refreshingAction: Selector(("footerRefresh")))
//		self.table.mj_footer = footer
		
		self.headerRefresh()
		self.footerRefresh()
		
		getdata(index: page)
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}

	//设置cell的数量
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.timeDataArray.count
	}
	
	//设置section的数量
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0.01
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.01
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return nil
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return nil
	}
	
	//设置tableview的cell
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = (table.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)) as UITableViewCell
		let model:TimeDataModel = self.timeDataArray[indexPath.row]
		cell.textLabel?.text = model.startTime
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let model:TimeDataModel = self.timeDataArray[indexPath.row]
		
		print("起始时间：" + model.startTime)
		print("结束时间：" + model.endTime)
		print("数据个数：" + model.data);
		
	}
	
	// 从服务器获取
	func getdata(index:Int){
		var parameters = [String: Any]()
		BFunction.shared.showLoading()
		let urlString = api_service + "/getmask"
		let userDefaults = UserDefaults.standard
		parameters["userid"] = userDefaults.value(forKey: "userid")
		parameters["page"] = "\(index)";
		parameters["pagesize"] = "10";
		Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
			BFunction.shared.hideLoadingMessage()
			self.table.mj_header.endRefreshing()
			self.table.mj_footer.endRefreshing()
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
						//var fatherArray:[TimeDataModel] = [TimeDataModel]()
					//	var sonArray:[FaceDataModel] = [FaceDataModel]()
						
						
						for (index,value) in data.enumerated() {
							// 这样子遍历，可以得到数组的值和下标
							print("index:\(index) = \(value)")
							
							let model:FaceDataModel = FaceDataModel.mj_object(withKeyValues: value);
							self.faceDataArray.append(model)
						}
						
						self.adjustData(data: self.faceDataArray)
						self.table.reloadData()
						
					}else {
						SVProgressHUD.showError(withStatus: getLocalizableString(key: "mask_data_fail", common: "获取面膜数据失败") )
					}
				}
				
			}
		}
		
	}
	
	// 将数据分组
	func adjustData(data:[FaceDataModel]) {
		var sonArray:[FaceDataModel] = [FaceDataModel]()
		self.timeDataArray.removeAll()
		
		for (index,value) in data.enumerated() {
			// 这样子遍历，可以得到数组的值和下标
			print("index:\(index) = \(value)")
			
			sonArray.append(value);
			if sonArray.count < 5 && index != data.count-1{
				continue;
			}
			let timeModel:TimeDataModel = TimeDataModel()
			let firstModel:FaceDataModel = sonArray.first!
			let lastModel:FaceDataModel = sonArray.last!
			
			timeModel.startTime = firstModel.time
			timeModel.endTime = lastModel.time
			timeModel.data = sonArray
			self.timeDataArray.append(timeModel)
			sonArray .removeAll()
		}
		print(self.timeDataArray)
		self.table .reloadData()
	}
	
	func headerRefresh() {
		self.table.mj_header = MJRefreshNormalHeader(refreshingBlock: {
			self.page = 0
			self.faceDataArray.removeAll()
			self.timeDataArray.removeAll()
			self.getdata(index: self.page)
		})
	}
	
	func footerRefresh() {
		self.table.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
			self.page = self.page + 1
			self.getdata(index: self.page)
		})
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
