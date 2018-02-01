//
//  BaseTableViewController.swift
//  DigitalCampus
//
//  Created by MakongYa on 16/9/25.
//  Copyright © 2016年 mky. All rights reserved.
//

import UIKit
class BaseTableViewController: BaseVC {
    @IBOutlet weak var _tableView: UITableView!
    var viewModel: TableViewModel!
    var isNoMoreData = false {
        didSet {
            removeErrorBgView()
            BFunction.shared.hideLoadingMessage()
            _tableView.mj_header.endRefreshing()
            _tableView.mj_footer?.isHidden = false
            
            if isNoMoreData {
                _tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                _tableView.mj_footer.endRefreshing()
            }
            _tableView.reloadData()
        }
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = TableViewModel()
        _tableView.delegate = viewModel
        _tableView.dataSource = viewModel
        _tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

// MARK: - event、response
extension BaseTableViewController {
    /// cell点击事件(必须调用setupSelectCell方法)
    func didSelectCell(at indexPath: IndexPath) {
        
    }
}

// MARK: - setter、getter
extension BaseTableViewController {
    // 为了适配4.0 已经不允许覆盖方法了，如果遇到错误请解决。
//    override func showErrorBgView() {
//        _tableView.mj_header?.endRefreshing()
//        _tableView.mj_footer?.endRefreshing()
//        _tableView.isHidden = true
//        super.showErrorBgView()
//    }
//    override func removeErrorBgView() {
//        _tableView.isHidden = false
//        super.removeErrorBgView()
//    }
    /// 设置数据
    func setupData() {
        
    }
    /// 设置cell点击回调（继承didSelectCell方法获取点击回调）
    func setupSelectCell() {
        viewModel.selectionBlock = { [weak self] (indexPath: IndexPath, tableView: UITableView, data:Any?) -> Void in
            self?.didSelectCell(at: indexPath)
        }
    }
}
