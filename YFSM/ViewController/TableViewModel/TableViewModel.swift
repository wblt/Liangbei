//
//  TableViewModel.swift
//  TestTableViewModel
//
//  Created by luo on 16/5/19.
//  Copyright © 2016年 luo. All rights reserved.
//

import UIKit

typealias ViewRenderBlock       = (_ section: Int, _ tableView: UITableView) -> UIView
typealias CellRenderBlock       = (_ indexPath: IndexPath, _ tableView: UITableView, _ data: Any?) -> UITableViewCell
typealias CellSelectionBlock    = (_ indexPath: IndexPath, _ tableView: UITableView, _ data: Any?) -> Void
typealias CellCommitEditBlock   = (_ indexPath: IndexPath, _ tableView: UITableView) -> Void
typealias CellWillDisplayBlock  = (_ cell: UITableViewCell, _ indexPath: IndexPath, _ tableView: UITableView) -> Void

class TableViewModel: NSObject {
    
    /// 每个section的数据
    var sectionModelArray: [TableViewSectionModel]!
    /// cellForRowAt
    var cellRenderBlock: CellRenderBlock?
    /// didSelectRowAt
    var selectionBlock: CellSelectionBlock?
    /// deselection
    var deselectionBlock: CellSelectionBlock?
    /// commitEdit
    var commitEditBlock: CellCommitEditBlock?
    /// sectionIndexTitles
    var sectionIndexTitles: [String]?
    
    override init() {
        sectionModelArray = []
    }
}

// MARK: - delegate
extension TableViewModel: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionModelArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionModel = sectionModelAtSection(section)
        return sectionModel.cellModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = cellModelAtIndexPath(indexPath)
        if cellModel == nil {return UITableViewCell()}
        let data = cellModel!.cellData
        
        var cell:UITableViewCell!
        
        if let cellRenderBlock = cellRenderBlock {
            cell = cellRenderBlock(indexPath, tableView, data!)
            return cell
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionModel = sectionModelAtSection(section)
        return sectionModel.headerTitle
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        let sectionModel = sectionModelAtSection(section)
        return sectionModel.footerTitle
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cellModel = cellModelAtIndexPath(indexPath)
        return cellModel!.height
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionModel = sectionModelAtSection(section)
        return sectionModel.headerHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let sectionModel = sectionModelAtSection(section)
        return sectionModel.footerHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionModel = sectionModelAtSection(section)
        let headerViewRenderBlock = sectionModel.headerViewRenderBlock
        
        if let headerViewRenderBlock = headerViewRenderBlock {
            return headerViewRenderBlock(section, tableView)
        }else{
            return sectionModel.headerView
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let sectionModel = sectionModelAtSection(section)
        let footerViewRenderBlock = sectionModel.footerViewRenderBlock
        
        if let footerViewRenderBlock = footerViewRenderBlock {
            return footerViewRenderBlock(section, tableView)
        }else{
            return sectionModel.footerView
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellModel = cellModelAtIndexPath(indexPath)
        
        var data: Any?
        if let cellModel = cellModel {
            data = cellModel.cellData
        }
        
        selectionBlock?(indexPath, tableView, data)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cellModel = cellModelAtIndexPath(indexPath)
        
        var data:Any!
        if let cellModel = cellModel {
            data = cellModel.cellData
        }
        deselectionBlock?(indexPath, tableView, data)
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        let cellModel = cellModelAtIndexPath(indexPath)
        return cellModel?.deleteConfirmationButtonTitle
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let cellModel = cellModelAtIndexPath(indexPath)
        return cellModel == nil ? true : cellModel!.isCanEdit
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        commitEditBlock?(indexPath, tableView)
    }
}

// MARK: - getters、setters
extension TableViewModel {
    
    /**
     根据section获取数据
     
     - parameter section: section
     
     - returns: TableViewSectionModel
     */
    func sectionModelAtSection(_ section: Int) -> TableViewSectionModel {
        
        if sectionModelArray.isEmpty {
            return TableViewSectionModel()
        }
        
        let sectionModel = sectionModelArray[section]
        return sectionModel
    }
    
    /**
     根据row获取数据
     
     - parameter indexPath: IndexPath
     
     - returns: TableViewCellModel
     */
    func cellModelAtIndexPath(_ indexPath: IndexPath) -> TableViewCellModel? {
        
        guard !sectionModelArray.isEmpty else {
            return nil
        }
        
        let sectionModel = sectionModelArray[indexPath.section]
        
        guard !sectionModel.cellModelArray.isEmpty else {
            return nil
        }
        
        let cellModel = sectionModel.cellModelArray[indexPath.row]
        
        return cellModel
    }
}
