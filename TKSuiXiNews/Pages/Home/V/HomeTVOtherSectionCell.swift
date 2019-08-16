//
//  HomeTVOtherSectionCell.swift
//  TKSuiXiNews
//
//  Created by Barry Allen on 2019/7/29.
//  Copyright © 2019 Barry Allen. All rights reserved.
//

import UIKit


///濉溪TV的CollectionViewCell
class HomeTVOtherSectionCollectionCell: UICollectionViewCell {
    var title:String? {
        willSet(newValue) {
            view.title = newValue
        }
    }
    
    var imageUrl: String? {
        willSet(newValue) {
            view.imageName = newValue
        }
    }
    
    var videoPlayeBlock: () -> Void = { }
    
    private lazy var view: HomeTVDetailPlayerView = {
        let view = HomeTVDetailPlayerView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(13 * iPHONE_AUTORATIO)
            make.right.equalTo(-13 * iPHONE_AUTORATIO)
        }
        
        view.videoBlock = { [weak self] in
            self?.videoPlayeBlock()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate let cellIdentifier = "HomeTVOtherSectionCollectionCellIdentifier"

class HomeTVOtherSectionCell: BaseTableViewCell {
    var checkTotalBlock: ()-> Void = {  }
    
    var title:String? {
        willSet(newValue) {
            titleLabel.text = newValue ?? "";
        }
    }
    
    var dataSource: [HomeTVTitleModel]? {
        willSet(newValue) {
            if let value = newValue {
                var source = value
                if value.count > 2 {
                    source = Array(value[0...1])
                } else {
                    source = value
                }
                _dataSource = source
                collectionView.reloadData()
            }
        }
    }
    
    private lazy var _dataSource: [HomeTVTitleModel] = {
       return [HomeTVTitleModel]()
    }()
    
    var videoBlock: (Int) -> Void = { _ in }

    var videoDetailBlock: (String) -> Void = { _ in}
    
    private lazy var upView: UIView = {
        let view = UIView();
        view.backgroundColor = RGBA(245, 245, 245, 1);
        return view;
    }();

    //MARK: - 濉溪新闻
    private lazy var titleLabel: UILabel = {
        let label = UILabel();
        label.font = kFont(14 * iPHONE_AUTORATIO);
        return label;
    }();
    
    private lazy var line: UIView = {
        let line = UIView();
        line.backgroundColor = RGBA(244, 244, 244, 1);
        return line;
    }();
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: K_SCREEN_WIDTH/2, height: 146 * iPHONE_AUTORATIO)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeTVOtherSectionCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    //全部按钮
    private lazy var indicationButton: UIButton = {
        let button = UIButton(type: .custom);
        button.addTarget(self,
                         action: #selector(didTappedTotalButton(_:)),
                         for: .touchUpInside)
        return button
    }();
    
    //全部的label
    private lazy var buttonTitleL: UILabel = {
        let label = UILabel();
        label.font = kFont(12 * iPHONE_AUTORATIO);
        label.text = "全部"
        label.textColor = RGBA(170, 170, 170, 1);
        return label;
    }();
    
    //全部的image
    private lazy var buttonImageV: UIImageView = {
        let imageView = UIImageView();
        imageView.image = K_ImageName("more_news_indicator");
        return imageView;
    }();
    
    override func setupUI() {
        super.setupUI();
        
        contentView.addSubview(upView)
        upView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview();
            make.height.equalTo(15 * iPHONE_AUTORATIO);
        }
        
        contentView.addSubview(titleLabel);
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10 * iPHONE_AUTORATIO);
            make.top.equalTo(30 * iPHONE_AUTORATIO);
            
        }
        
        contentView.addSubview(indicationButton)
        indicationButton.snp.makeConstraints { (make) in
            make.right.equalTo(0);
            make.centerY.equalTo(titleLabel.snp_centerY);
            make.size.equalTo(CGSize(width: 60 * iPHONE_AUTORATIO, height: 43 * iPHONE_AUTORATIO));
        }
        
        //增加标签和图片
        indicationButton.addSubview(buttonImageV)
        buttonImageV.snp.makeConstraints { (make) in
            make.right.equalTo(-10 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
            make.size.equalTo(CGSize(width: 7 * iPHONE_AUTORATIO, height: 12 * iPHONE_AUTORATIO));
        }
        
        indicationButton.addSubview(buttonTitleL)
        buttonTitleL.snp.makeConstraints { (make) in
            make.right.equalTo(buttonImageV.snp_left).offset(-5 * iPHONE_AUTORATIO);
            make.centerY.equalToSuperview();
        }
        
        contentView.addSubview(line);
        line.snp.makeConstraints { (make) in
            make.left.equalTo(10 * iPHONE_AUTORATIO);
            make.right.equalTo(-10 * iPHONE_AUTORATIO);
            make.top.equalTo(58 * iPHONE_AUTORATIO);
            make.height.equalTo(1);
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp_bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
    }

    @objc private func didTappedTotalButton(_ sender: UIButton) {
        checkTotalBlock()
    }
}

extension HomeTVOtherSectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = _dataSource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeTVOtherSectionCollectionCell
        cell.title = model.name.string
        cell.imageUrl = model.image.string
        cell.videoPlayeBlock = { [weak self] in
            self?.videoBlock(model.id.int)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = _dataSource[indexPath.row]
        videoDetailBlock(model.id.string)
    }
}
