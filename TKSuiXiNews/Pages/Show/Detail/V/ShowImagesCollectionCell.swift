//
//  ShowImagesCollectionCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "BaseWrapCollectionCellIdentifier";

fileprivate let layoutWidth = 110 * iPHONE_AUTORATIO;

class ShowImagesCollectionCell: BaseTableViewCell {

    //获取照片的数据
    var images:Array<String>? {
        willSet(value) {
            dataSource = value ?? [];
        }
    }
    
    //获取照片的
    private lazy var dataSource: Array<String> = {
        return [String]();
    }();
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: layoutWidth, height: layoutWidth)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0;
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
        collectionView.backgroundColor = .white;
        collectionView.isScrollEnabled = false;
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BaseWrapCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier);
        return collectionView;
    }();
    
    override func setupUI() {
        super.setupUI();
        
        addSubview(collectionView);
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(13 * iPHONE_AUTORATIO);
            make.top.equalTo(20 * iPHONE_AUTORATIO);
            make.right.equalTo(-13 * iPHONE_AUTORATIO);
            make.bottom.equalToSuperview();
        }
    }
    
}

extension ShowImagesCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! BaseWrapCollectionCell
        cell.imageName = dataSource[indexPath.row];
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //显示图片浏览器
        let index = indexPath.row
        let images = dataSource
        PhotoBrowser.showImages(original: index, photos: images)
    }
}
