//
//  SearchDeviceView.swift
//  YFSMM
//
//  Created by Alvin on 2017/8/9.
//  Copyright © 2017年 Alvin. All rights reserved.
//

import UIKit

protocol SearchDeviceViewDelegate {
    func searchDeviceView(_ searchDeviceView:SearchDeviceView,didSelectRowAt index:Int)
    func dissmissOfView(_ searchDeviceView:SearchDeviceView)
}

class SearchDeviceView: UIView,UITableViewDelegate,UITableViewDataSource {
    fileprivate var block:CompletionBlock!
    typealias CompletionBlock =  @convention(block)(_ index:Int) -> Void
    
    var delegate:SearchDeviceViewDelegate?
    fileprivate var dataArray:[CBPeripheral] = []
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.contentView.layer.cornerRadius = 8
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        closeBtn.setCornerBorderWithCornerRadii(self.closeBtn.frame.height / 2 , width: 1, color: UIColorHex("999999"))
  
    }
    
    func setData(dataArray:[CBPeripheral]) {
        self.dataArray = dataArray
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let peripheral = self.dataArray[indexPath.row]
        print("名子："+peripheral.identifier.uuidString)
        cell?.textLabel?.text = peripheral.identifier.uuidString.components(separatedBy: "-")[0]
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.searchDeviceView(self, didSelectRowAt: indexPath.row)
        self.delegate?.dissmissOfView(self)
        self.hide()
    }
    
    func show() {

        self.frame = CGRect(x: 0, y: 0, width: kScreenFrameW, height: kScreenFrameH)
        self.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: kScreenFrameH, width: self.contentView.frame.width, height: self.contentView.frame.height)
        let opacityAnimation: CABasicAnimation! = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = Float(0)
        opacityAnimation.toValue = Float(0.5)
        opacityAnimation.isRemovedOnCompletion = true
        self.layer.add(opacityAnimation, forKey: "animationGroup")
        
        UIApplication.shared.keyWindow!.addSubview(self)
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: (kScreenFrameH / 2) - (self.contentView.frame.height / 2) , width: self.contentView.frame.width, height: self.contentView.frame.height)
            // self.alpha = 0.7
        })
        
    }
    fileprivate func hide() {
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: kScreenFrameH, width: self.contentView.frame.width, height: self.contentView.frame.height)
        }, completion: {(finished: Bool) -> Void in
            self.removeFromSuperview()
        })
        
        
        
    }
    @IBAction func closeClick(_ sender: Any) {
        self.delegate?.dissmissOfView(self)
        self.hide()
    }

}
