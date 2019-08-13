//
//  SpecialHomeTitleBannerCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import FSPagerView
import UIKit

/*
 * 头部Banner的Cell
 */
fileprivate let layoutWidth = K_SCREEN_WIDTH/4

fileprivate let cellIdentifier = "SpecialColumnSingleCellIdentifier"

class SpecialHomeTitleBannerCell: FSPagerViewCell {
    //MARK: - 选择的cell索引
    var _selectedIndex: Int?
    
    var selectedBlock: (Int) -> Void = { _ in }
    
    var _isReload:Bool = true {
        willSet {
            collectionView.reloadData()
        }
    }
    
    //数据
    var dataSource:[ArticleAdminModelDatum] = [ArticleAdminModelDatum]() {
        willSet(newValue) {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: layoutWidth, height: layoutWidth)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
        collectionView.backgroundColor = .white;
        collectionView.isScrollEnabled = false;
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SpecialColumnSingleCell.self, forCellWithReuseIdentifier: cellIdentifier);
        return collectionView;
    }()
    
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

extension SpecialHomeTitleBannerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SpecialColumnSingleCell
        if let index = _selectedIndex, index == indexPath.row { cell.isChoose = true } else { cell.isChoose = false }
        cell.imagename = model.avatar.string
        cell.title = model.nickname.string
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedBlock(indexPath.row)
    }
}
