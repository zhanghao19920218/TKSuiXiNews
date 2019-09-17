//
//  HomeTotalChildVideoController.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/1.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let totalCollecIdentifier = "HomeTotalCollectionCellIdentifier"

class SXHomeTotalChildVideoController: BaseCollectionViewController {
    var secondModule:String = "濉溪新闻"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupUI()
    }
    
    //MARK: - 初始化
    private func _setupUI() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.backgroundColor = .white
        collectionView.register(SXHomeTotalCollectionCell.self, forCellWithReuseIdentifier: totalCollecIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func loadData() {
        super.loadData();
        
        requestData(); //请求数据
    }
    
    override func pullDownRefreshData() {
        super.pullDownRefreshData()
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.secondModule(module: "濉溪TV", module_second: secondModule, page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXTVSecondModuleResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            self?.dataSource = forceModel.data.data;
            self?.collectionView.mj_header.endRefreshing()
            self?.collectionView.reloadData();
            }, failure:{ [weak self] () in
                self?.collectionView.mj_header.endRefreshing()
                self?.collectionView.reloadData();
            }
        )
    };
    
    
    override func pullUpLoadMoreData() {
        super.pullUpLoadMoreData()
        
        page = (page == 1 ? 2 : page);
        
        //请求成功进行再次刷新数据
        HttpClient.shareInstance.request(target: BAAPI.secondModule(module: "濉溪TV", module_second: secondModule, page: page), success:{ [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXTVSecondModuleResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }
            
            if forceModel.data.data.count != 0 {
                //页数+1
                self?.page += 1;
                self?.dataSource += forceModel.data.data;
                self?.collectionView.mj_footer.endRefreshing()
                self?.collectionView.reloadData();
            } else {
                //没有更多数据
                self?.collectionView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            }, failure:{ [weak self] () in
                self?.collectionView.mj_footer.endRefreshing()
                self?.collectionView.reloadData();
            }
        )
    }
}


extension SXHomeTotalChildVideoController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource[indexPath.row] as! SXSecondModuleModel
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: totalCollecIdentifier, for: indexPath) as! SXHomeTotalCollectionCell
        cell.imageName = model.image.string
        cell.title = model.name.string
        cell.videoBlock = { [weak self] in
            let vc = OnlineTVShowViewController(url: model.video.string)
            vc.id = model.id.int
            self?.navigationController?.pushViewController(vc, animated: true);
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row] as! SXSecondModuleModel
        let vc = SXVideoNewsDetailController()
        vc.id = model.id.string
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168 * iPHONE_AUTORATIO, height: 130 * iPHONE_AUTORATIO)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15 * iPHONE_AUTORATIO, left: 15 * iPHONE_AUTORATIO, bottom: 15 * iPHONE_AUTORATIO, right: 15 * iPHONE_AUTORATIO)
    }
}

extension SXHomeTotalChildVideoController {
    //MARK: - 请求首页数据
    private func requestData(){
        HttpClient.shareInstance.request(target: BAAPI.secondModule(module: "濉溪TV", module_second: secondModule, page: page), success: { [weak self] (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(SXTVSecondModuleResponse.self, from: json)
            guard let forceModel = model else {
                return;
            }

            self?.dataSource = forceModel.data.data;
            self?.collectionView.reloadData();
            }
        )
    }
}

