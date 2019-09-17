//
//  HomeVSendCollectionView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/24.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

/*
 * 发送图文的view
 */

fileprivate let cellIdentifier = "BaseWrapCollectionCellIdentifier";

fileprivate let layoutWidth = 90 * iPHONE_AUTORATIO;

class SXHomeVSendCollectionView: UIView {
    var deleteBlock: (Int) -> Void = { _ in }
    /*
     * 点击选择更多照片的Block
     */
    var block = { () in }

    //获取照片的数据
    var images:Array<String>? {
        willSet(value) {
            _dataSource = value ?? [];
            _collectionView.reloadData();
        }
    }
    
    //获取照片的
    private lazy var _dataSource: Array<String> = {
        return [String]();
    }();
    
    private lazy var _collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: layoutWidth, height: layoutWidth)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0;
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
        collectionView.backgroundColor = .white;
        collectionView.isScrollEnabled = false;
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SXBaseWrapCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier);
        return collectionView;
    }();
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(_collectionView);
        _collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    
    @objc private func deleteImageButton(_ sender: UIButton) {
        deleteBlock(sender.tag)
        _dataSource.remove(at: sender.tag)
        _collectionView.reloadData()
    }
    
}

extension SXHomeVSendCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if _dataSource.count == 9 {
            return 9;
        }
        return _dataSource.count + 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == _dataSource.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SXBaseWrapCollectionCell
            cell.imagev.image = K_ImageName("add_photo");
            cell.deleteButton.isHidden = true
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SXBaseWrapCollectionCell
        cell.imageName = _dataSource[indexPath.row];
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.isHidden = false
        cell.deleteButton.addTarget(self,
                                    action: #selector(deleteImageButton(_:)),
                                    for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == _dataSource.count {
            block();
        } else {
            //显示图片浏览器
            let index = indexPath.row
            let images = _dataSource
            PhotoBrowser.showImages(original: index, photos: images)
        }
    }
}