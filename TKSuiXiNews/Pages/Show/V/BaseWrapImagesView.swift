//
//  BaseWrapImagesView.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/21.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let layoutWidth = 95 * iPHONE_AUTORATIO;

//MARK: - 里面的collectionViewCell
class BaseWrapCollectionCell: UICollectionViewCell {
    //照片名称
    var imageName:String? {
        willSet(value) {
            if let imageUrl = value {
                imagev.kf.setImage(with: URL(string: imageUrl), placeholder: K_ImageName(PLACE_HOLDER_IMAGE));
            }
        }
    }
    
    private lazy var imagev:UIImageView = {
        let imageView = UIImageView.init();
        imageView.image = K_ImageName(PLACE_HOLDER_IMAGE);
        return imageView;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(imagev);
        imagev.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        };
    }
    
}

fileprivate let cellIdentifier = "BaseWrapCollectionCellIdentifier";

class BaseWrapImagesView: UIView {
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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0;
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
        collectionView.backgroundColor = .white;
        collectionView.isScrollEnabled = false;
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BaseWrapCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier);
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
        
        addSubview(collectionView);
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }

}

extension BaseWrapImagesView: UICollectionViewDelegate, UICollectionViewDataSource {
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
}
