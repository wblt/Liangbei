//
//  TableViewSectionModel.swift
//  TestTableViewModel
//
//  Created by luo on 16/5/19.
//  Copyright © 2016年 luo. All rights reserved.
//

import UIKit

class TableViewSectionModel {
    
    //每一行的数据
    var cellModelArray:[TableViewCellModel]!
    
    var headerViewRenderBlock: ViewRenderBlock?
    var footerViewRenderBlock: ViewRenderBlock?
    var headerTitle:String?
    var footerTitle:String?
    var headerHeight:CGFloat!
    var footerHeight:CGFloat!
    var headerView:UIView?
    var footerView:UIView?
    
    init() {
        headerHeight = UITableViewAutomaticDimension
        footerHeight = UITableViewAutomaticDimension
        cellModelArray = []
    }
}
