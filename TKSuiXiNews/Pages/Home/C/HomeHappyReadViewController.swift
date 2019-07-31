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
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _setupUI()
    }
    
    private func _setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-TAB_BAR_HEIGHT)
        }
    }
}

extension HomeHappyReadViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeHappyReadImageCell
        cell.imagename = "http://medium.tklvyou.cn/uploads/20190729/561891ee5604094965343ca574ae170b.jpg"
        cell.title = "文章名称文章名称文章名称文章名称文章名称"
        cell.reviewNum = 1265
        cell.time = "3小时前"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
            return CGSize(width: 165 * iPHONE_AUTORATIO, height: 25 * iPHONE_AUTORATIO)
        }
        return CGSize(width: 165 * iPHONE_AUTORATIO, height: 200 * iPHONE_AUTORATIO)
    }
}
