//
//  BaseGrouppedTableViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import ESPullToRefresh

class BaseGrouppedTableViewController: BaseViewController {

    //基类的tableView
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped);
        //iOS 11Self-Sizing自动打开后，contentSize和contentOffset都可能发生改变。可以通过以下方式禁用
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        return tableView;
    }();
    
    //当前页码
    lazy var page:Int = {
        let int = 1;
        return int;
    }();
    
    //当前的数据
    private lazy var _dataSource:Array<Any> = {
        let array = [Any]();
        return array;
    }();
    
    //设置
    var dataSource: Array<Any> {
        set(value){
            _dataSource = value;
            //发送通知
            NotificationCenter.default.post(name: .noData, object: self);
        }
        
        get {
            return _dataSource;
        }
    }
    
    //最基本显示没有数据的view
    private lazy var baseNoDataView: NoMoreDataView = {
        let view = NoMoreDataView();
        return view;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        //监听数据是否为空数组
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dataSourcesStatusChanged(_:)),
                                               name: .noData,
                                               object: self);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NotificationCenter.default.removeObserver(self);
    }
    
    //初始化tableView
    private func setupUI()
    {
        
        //添加tableView
        view.addSubview(tableView);
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        });
        
//        tableView.tableFooterView = UIView.init();
        //增加下拉刷新
        tableView.es.addPullToRefresh {
            [unowned self] in
            //加载更多数据
            self.pullDownRefreshData();
        }
        
        //增加上拉加载更多
        tableView.es.addInfiniteScrolling {
            [unowned self] in
            /// Do anything you want...
            /// ...
            /// If common end
            self.pullUpLoadMoreData()
        }
        
        //添加暂无内容
        view.addSubview(baseNoDataView);
        baseNoDataView.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
            make.size.equalTo(CGSize(width: 200 * iPHONE_AUTORATIO, height: 184 * iPHONE_AUTORATIO));
        };
    }
    
    
    /**
     * 下拉加载是否可以显示
     */
    func pullDownRefreshData()
    {
        page = 1;
        _dataSource = [];
        tableView.es.resetNoMoreData();
    }
    
    /**
     * 上拉可以加载更多
     */
    func pullUpLoadMoreData()
    {
    }
    
    /**
     * 监听数据变化
     */
    @objc func dataSourcesStatusChanged(_ notification: Notification) {
        //Do something globally here!
        let dataSourceNoti = notification.object as! BaseGrouppedTableViewController;
        
        //        print("数据变化: \(notification.userInfo)");
        //监听数据变化
        if dataSourceNoti._dataSource.isEmpty {
            print("暂无数据")
            DispatchQueue.main.async { [weak self] () in
                //不加这句导致界面还没初始化完成就打开警告框，这样不行
                self?.baseNoDataView.isHidden = false;
            }
        } else {
            print("有数据")
            DispatchQueue.main.async { [weak self] () in
                //不加这句导致界面还没初始化完成就打开警告框，这样不行
                self?.baseNoDataView.isHidden = true;
            }
        }
    }

}
