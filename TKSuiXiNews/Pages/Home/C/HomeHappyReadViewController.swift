//
//  HomeHappyReadViewController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/30.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit
import WaterfallLayout

/*
 * 悦读
 */

fileprivate let cellIdentifier = "HomeHappyReadImageCellIdentifier"

class HomeHappyReadViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()
        layout.delegate = self
        layout.sectionInset = UIEdgeInsets(top: 15 * iPHONE_AUTORATIO, left: 15 * iPHONE_AUTORATIO, bottom: 15 * iPHONE_AUTORATIO, right: 15 * iPHONE_AUTORATIO)
        layout.minimumLineSpacing = 15 * iPHONE_AUTORATIO
        layout.minimumInteritemSpacing = 15 * iPHONE_AUTORATIO
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeHappyReadImageCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellIdentifier")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = RGBA(239, 239, 239, 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _setupUI()
        
        requestData()
    }
    
    private func _setupUI() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        //增加下拉刷新
        collectionView.es.addPullToRefresh {
            [unowned self] in
            //加载更多数据
            self.pullDownRefreshData();
        }
        
        //增加上拉加载更多
        collectionView.es.addInfiniteScrolling {
            [unowned self] in
            /// Do anything you want...
            /// ...
            /// If common end
            self.pullUpLoadMoreData()
        }
    }
    
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
    
    
    /**
     * 下拉加载是否可以显示
     */
    func pullDownRefreshData()
    {
        page = 1;
        _dataSource = [];
        collectionView.es.resetNoMoreData();
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "悦读", page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeHappyReadResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data
            self?.collectionView.es.stopPullToRefresh();
            self?.collectionView.reloadData();
            }, failure:{ [weak self] () in
                self?.collectionView.es.stopPullToRefresh();
                self?.collectionView.reloadData();
            }
        )
    }
    
    /**
     * 上拉可以加载更多
     */
    func pullUpLoadMoreData()
    {
        page = (page == 1 ? 2 : page);
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "悦读", page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeHappyReadResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            if forceModel.data.data.count != 0 {
                //页数+1
                self?.page += 1;
                self?.dataSource += forceModel.data.data;
                self?.collectionView.es.stopLoadingMore();
                self?.collectionView.reloadData();
            } else {
                //没有更多数据
                self?.collectionView.es.noticeNoMoreData();
            }
            
            }, failure:{ [weak self] () in
                self?.collectionView.es.stopLoadingMore();
                self?.collectionView.reloadData();
            }
        )
    }
}

extension HomeHappyReadViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = dataSource[indexPath.row] as! HomeHappyReadListItemModel
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeHappyReadImageCell
        cell.imagename = model.image.string
        cell.title = model.name.string
        cell.reviewNum = model.visitNum.int
        cell.time = model.begintime.string
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! HomeHappyReadListItemModel
        let vc = HomeNewsDetailInfoController();
        vc.id = model.id.string
        vc.title = "悦读"
        navigationController?.pushViewController(vc, animated: true)
        //如果取消点赞或者成功点赞刷新页面
        vc.parametersBlock = { [weak self] (comment, review, like, likeStatus) in
            //获取要刷新的索引
            let indexPaths = [indexPath]
            //更新索引的数据
            var changeModel = self?.dataSource[indexPath.row] as! HomeHappyReadListItemModel
            changeModel.visitNum.int = review
            self?.dataSource[indexPath.row] = changeModel
            //刷新页面
            collectionView.reloadItems(at: indexPaths)
        }
    }
}

extension HomeHappyReadViewController: WaterfallLayoutDelegate {
    func collectionViewLayout(for section: Int) -> WaterfallLayout.Layout {
        switch section {
        default: return .waterfall(column: 2, distributionMethod: .balanced)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: 165 * iPHONE_AUTORATIO, height: 225 * iPHONE_AUTORATIO)
        }
        return CGSize(width: 165 * iPHONE_AUTORATIO, height: 200 * iPHONE_AUTORATIO)
    }

}

extension HomeHappyReadViewController {
    //MARK: - 请求数据
    private func requestData() {
        HttpClient.shareInstance.request(target: BAAPI.contentList(module: "悦读", page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(HomeHappyReadResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }

            self?.dataSource = forceModel.data.data
            self?.collectionView.reloadData()
            }
        )
    }
}
