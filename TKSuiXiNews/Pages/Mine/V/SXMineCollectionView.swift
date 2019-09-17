//
//  MineCollectionView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/22.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "BaseWrapCollectionCellIdentifier";

fileprivate let layoutWidth = 90 * iPHONE_AUTORATIO

typealias ClickIndexBlock = (_ index:Int)->(Void)

class SXMineCollectionView: UIView {
    
    ///点击的Block
    var mineBlock:ClickIndexBlock?
    
    ///未读消息数量
    private var _unreadMsgCount: Int?
    
    var unreadMsgNum: Int? {
        willSet(newValue) {
            //刷新页面
            _unreadMsgCount = newValue
            collectionView.reloadData()
        }
    }

    ///获取数据的数组
    private lazy var dataSource:[(imageName:String, title: String)] = {
        return  [
            (imageName: "favorite_icon", title: "我的收藏"),
            (imageName: "recent_icon", title: "最近浏览"),
            (imageName: "mine_labels_icon", title: "我的帖子"),
            (imageName: "ask_gov_icon", title: "问政记录"),
            (imageName: "message_icon", title: "我的消息"),
            (imageName: "change_icon", title: "兑换记录"),
            (imageName: "about_us_icon", title: "关于我们"),
        ]
    }()

    //下面的CollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: layoutWidth, height: layoutWidth)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
        collectionView.register(SXMineUsualCollCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.isScrollEnabled = false;
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white;
        return collectionView
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView);
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
}

extension SXMineCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SXMineUsualCollCell
        cell.imageName = dataSource[indexPath.row].imageName;
        cell.title = dataSource[indexPath.row].title
        if indexPath.row == 4 {
            ///未读消息数量
            cell.unread = _unreadMsgCount
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mineBlock != nil{
            mineBlock!(indexPath.item)
        }
    }
}