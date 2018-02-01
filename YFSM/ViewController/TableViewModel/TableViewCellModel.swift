//
//  TableViewCellModel.swift
//  TestTableViewModel
//
//  Created by luo on 16/5/19.
//  Copyright © 2016年 luo. All rights reserved.
//

import UIKit

class TableViewCellModel {
    
    var renderBlock: CellRenderBlock?
    var deleteConfirmationButtonTitle: String?
    var cellData: Any?
    
    var height: CGFloat!
    var isCanEdit = false
    
    init(_ data: Any?) {
        height = UITableViewAutomaticDimension
        cellData = data
    }
    
    init(_ data: Any?, height: CGFloat) {
        self.height = height
        cellData = data
    }
}
