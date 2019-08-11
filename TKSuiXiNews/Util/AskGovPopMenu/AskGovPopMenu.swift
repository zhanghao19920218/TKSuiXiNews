//
//  AskGovPopMenu.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/8/10.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit

fileprivate let layoutWidth = 95 * iPHONE_AUTORATIO
fileprivate let cellIdentifier = "SpecialColumnSingleCellIdentifier"

class AskGovPopMenu: UIView {
    var selectedBlock: (String) -> Void = { _ in }
    
    //数据
    private var dataSource:[ArticleAdminModelDatum] = [ArticleAdminModelDatum]() {
        willSet(newValue) {
            collectionView.reloadData()
        }
    }
    
    //弹窗背景
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10 * iPHONE_AUTORATIO
        return view
    }()

    //显示标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = kBoldFont(14 * iPHONE_AUTORATIO)
        label.text = "选择问政对象"
        return label
    }()
    
    //置顶的model
    var topModel: ArticleAdminModelResponse?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: layoutWidth - (20 * iPHONE_AUTORATIO), height: layoutWidth)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout);
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SpecialColumnSingleCell.self, forCellWithReuseIdentifier: cellIdentifier);
        return collectionView;
    }()
    
    //初始化页面
    private override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupUI(frame: frame)
    }
    
    @objc private func tapGestureRecognizerAction(_ sender:UITapGestureRecognizer) {
        tappedCancel();
    }
    
    //取消
    private func tappedCancel() {
        self.removeFromSuperview();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化界面
    private func setupUI(frame: CGRect) {
        let alertBgView = UIView.init(frame: frame);
        alertBgView.tag = 100;
        alertBgView.backgroundColor = RGBA(0, 0, 0, 0.6);
        alertBgView.isUserInteractionEnabled = true;
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureRecognizerAction(_:)))
        alertBgView.addGestureRecognizer(tap);
        addSubview(alertBgView);
        
        //背景
        addSubview(backView);
        backView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 315 * iPHONE_AUTORATIO, height: 255 * iPHONE_AUTORATIO))
        };
        
        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(25 * iPHONE_AUTORATIO)
            make.centerX.equalToSuperview()
        }
        
        
        backView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(53 * iPHONE_AUTORATIO)
            make.left.equalTo(15 * iPHONE_AUTORATIO)
            make.right.equalTo(-15 * iPHONE_AUTORATIO)
            make.bottom.equalToSuperview()
        }
    }

    public static func show(array: [ArticleAdminModelDatum], success: @escaping (String) -> Void) {
        //获取当前页面
        let vc = UIViewController.current()
        
        let view = AskGovPopMenu(frame: CGRect(x: 0, y: 0, width: K_SCREEN_WIDTH, height: K_SCREEN_HEIGHT))
        vc?.navigationController?.view.addSubview(view)
        view.dataSource = array
        view.selectedBlock = { (content) in
            success(content)
        }
    }

}

extension AskGovPopMenu: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SpecialColumnSingleCell
        cell.imagename = model.avatar.string
        cell.title = model.nickname.string
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        selectedBlock(model.nickname.string)
        tappedCancel()
    }
}
