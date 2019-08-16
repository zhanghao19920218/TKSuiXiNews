//
//  BaseCollectionViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/31.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import MJRefresh

//MARK: - 积分商城的Controller

class BaseCollectionViewController: BaseViewController {

    //基类的tableView
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15 * iPHONE_AUTORATIO
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout);
        collectionView.backgroundColor = RGBA(238, 238, 238, 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        return collectionView;
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
        }
        
        get {
            return _dataSource;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
    }
    
    //初始化tableView
    private func setupUI()
    {
        
        //增加下拉刷新
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [unowned self] in
            //加载更多数据
            self.pullDownRefreshData();
        })
        
        //增加上拉加载更多
        collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            [unowned self] in
            /// Do anything you want...
            /// ...
            /// If common end
            self.pullUpLoadMoreData()
        })
        
    }
    
    
    /**
     * 下拉加载是否可以显示
     */
    func pullDownRefreshData()
    {
        page = 1;
        _dataSource = [];
        collectionView.mj_footer.resetNoMoreData()
    }
    
    /**
     * 上拉可以加载更多
     */
    func pullUpLoadMoreData()
    {
    }
    

}
